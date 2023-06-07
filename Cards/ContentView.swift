import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Card: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let title: String
    let text: String
}

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = [] // Add this line

    private var db = Firestore.firestore()

    func fetchData() {
        db.collection("cards").limit(to: 1).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: CardSet.self)
                    }
                    switch result {
                    case .success(let cardSet):
                        self.cards = cardSet.cardSets.map { Card(title: $0["0"] ?? "", text: $0["1"] ?? "") } // Update this line
                        print(self.cards)
                    case .failure(let error):
                        print("Error decoding card set: \(error)")
                    }
                }
            }
        }
    }
}

struct CardSet: Codable {
    let cardSets: [[String: String]]
}
struct ImageView: View {
    let url: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        }
    }
}

struct CodeView: View {
    let code: String

    var body: some View {
        Text(code)
            .font(.system(size: 10, design: .monospaced))
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
}
struct ContentView: View {
    @StateObject var cardViewModel = CardViewModel()
    
    @State private var currentIndex = 0
    @State private var shuffleIndex = 2
    @State private var offset: CGSize = .zero
    @State private var shuffledCards: [Card] = []
    @State private var currentCards: [Card] = []
    @State private var flippedCardIndices: Set<Int> = []
    var body: some View {
        
        ZStack {
            ForEach(currentCards.indices.reversed(), id: \.self) { index in
                if index >= currentIndex {
                    CardView(card: currentCards[index], isFlipped: flippedCardIndices.contains(index), swipeProgress: index == currentIndex ? offset.width : 0)
                        .offset(index == currentIndex ? offset : .zero)
                        .rotationEffect(.degrees(index == currentIndex ? Double(offset.width / 10) : 0))
                        .shadow(color: Color.black.opacity(index == currentIndex ? 0.1 : 0), radius: 20, x: 0, y: 0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if index == currentIndex {
                                        offset = gesture.translation
                                    }
                                }
                                .onEnded { gesture in
                                    if index == currentIndex {
                                        if abs(gesture.translation.width) > 200 {
                                            let screenWidth = UIScreen.main.bounds.width
                                            let translationDirectionX = gesture.translation.width > 0 ? screenWidth : -screenWidth
                                            let translationDirectionY = gesture.translation.height

                                            withAnimation(.easeOut(duration: 0.3)) {
                                                offset = CGSize(width: translationDirectionX * 1.5, height: translationDirectionY * 1.5)
                                            }

                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                updateCurrentCards()
                                                if currentIndex == currentCards.count {
                                                    currentIndex = 0
                                                }
                                                if shuffleIndex == shuffledCards.count-1 {
                                                    shuffleIndex = 0
                                                    shuffledCards = cardViewModel.cards.shuffled()
                                                }
                                                offset = .zero
                                            }
                                        } else {
                                            offset = .zero
                                        }
                                    }
                                }
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0)) {
                                if flippedCardIndices.contains(index) {
                                    flippedCardIndices.remove(index)
                                } else {
                                    flippedCardIndices.insert(index)
                                }
                            }
                        }
                }
            }
        }
            .onAppear {
                cardViewModel.fetchData()
            }
            .onChange(of: cardViewModel.cards) { newCards in // Add this block
                shuffledCards = newCards.shuffled()
                currentCards = Array(shuffledCards[0..<3])
            }
            .padding()
        }
    private func updateCurrentCards() {
        currentIndex += 1
        shuffleIndex += 1
        currentCards.append(shuffledCards[shuffleIndex])
    }
}

struct CardView: View {
    let card: Card
    let isFlipped: Bool
    let swipeProgress: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if isFlipped {
                ScrollView {
                    parseText(card.text)
                        .font(.system(size: 25))
                        .padding()
                }
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)) // Fix mirrored text
            } else {
                Text(card.title)
                    .font(.largeTitle).fontWeight(Font.Weight.bold)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(10)
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
    func parseText(_ text: String) -> some View {
        let imgPattern = "\\[img\\](.*?)\\[/img\\]"
        let codePattern = "\\[code\\]([\\s\\S]*?)\\[/code\\]"
        let combinedPattern = "(?:\(imgPattern)|\(codePattern))"
        
        let regex = try? NSRegularExpression(pattern: combinedPattern, options: [])
        let nsText = text as NSString
        let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length)) ?? []
        
        var parsedViews: [AnyView] = []
        var lastIndex = 0
        
        for match in matches {
            let range = match.range
            let imgRange = match.range(at: 1)
            let codeRange = match.range(at: 2)
            
            if range.location > lastIndex {
                let textRange = NSRange(location: lastIndex, length: range.location - lastIndex)
                let plainText = nsText.substring(with: textRange)
                parsedViews.append(AnyView(Text(plainText)))
            }
            
            if imgRange.length > 0 {
                let url = nsText.substring(with: imgRange)
                    .replacingOccurrences(of: "[img]", with: "")
                    .replacingOccurrences(of: "[/img]", with: "")
                parsedViews.append(AnyView(ImageView(url: url)))
            } else if codeRange.length > 0 {
                let code = nsText.substring(with: codeRange)
                    .replacingOccurrences(of: "[code]", with: "")
                    .replacingOccurrences(of: "[/code]", with: "")
                parsedViews.append(AnyView(CodeView(code: code)))
            }
            
            lastIndex = range.location + range.length
        }
        
        if lastIndex < nsText.length {
            let textRange = NSRange(location: lastIndex, length: nsText.length - lastIndex)
            let plainText = nsText.substring(with: textRange)
            parsedViews.append(AnyView(Text(plainText)))
        }
        
        return AnyView(VStack(alignment: .leading, spacing: 8) {
            ForEach(parsedViews.indices, id: \.self) { index in
                parsedViews[index]
            }
        })
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
