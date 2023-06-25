//
//  CardSetList.swift
//  Cards
//
//  Created by Артем Чмиленко on 22.06.2023.
//

import SwiftUI
import WrapLayout
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift



class apiCalls{
    func generateCardSet(name: String, qc: Int, tags: [String], description: String){
        let url = URL(string: "https://cards-backend-python-91217e25d432.herokuapp.com/generate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "name": name,
            "questions_count": qc,
            "tags": tags,
            "description": description
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let str = String(data: data, encoding: .utf8)
                print("Received data:\n\(str ?? "")")
            }
        }

        task.resume()

    }
}

class CardsViewModel: ObservableObject {
    @Published var cards = [CardListItem]()
    @Published var pinnedSets = [CardListItem]()

    
    private var db = Firestore.firestore()
    
    init() {
        fetchPinned()
        fetchFeatured()
    }
    
    func fetchFeatured() {
        db.collection("cards").limit(to: 20).addSnapshotListener
        { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            print("Documents: \(documents.count)")
            for item in documents {
                print(item.data())
            }
            
            self.cards = documents.compactMap { queryDocumentSnapshot -> CardListItem? in
                return try? queryDocumentSnapshot.data(as: CardListItem.self)
            }
        }
    }
    
    func fetchPinned() {
        let data = Data()
        data.loadDefaults()
        let group = DispatchGroup()
        
        guard let unwarppedPinnedSet = data.pinnedSets else { return }
        
            for id in unwarppedPinnedSet {
                group.enter()
                db.collection("cards").whereField("id", isEqualTo: id).getDocuments { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        group.leave()
                        return
                    }
                    
                    print("Documents: \(documents.count)")
                    for item in documents {
                        print(item.data())
                    }
                    
                    let newPinnedSets = documents.compactMap { queryDocumentSnapshot -> CardListItem? in
                        return try? queryDocumentSnapshot.data(as: CardListItem.self)
                    }
                    
                    self.pinnedSets.append(contentsOf: newPinnedSets)
                    group.leave()
                }
            }
            
        group.notify(queue: .main) {
            print("Finished all requests.")
        }
    }
}

struct CardListItem: Identifiable, Codable {
    var id: String
    var cardSets: [[String: String]]
    var name: String
    var ownerID: String
    var description: String
    var tags: [String]
}

struct Constants {
    static let primaryBlue: Color = Color(red: 0.29, green: 0.57, blue: 1).opacity(0.3)
    static let primaryDarkBlue: Color = Color(red: 0.16, green: 0.39, blue: 0.74)
    static let primaryWhite: Color = .white
    static let primaryBlack: Color = .black
}

struct CardItem: View {
    var icon: String
    var title: String
    var id: String
    var description: String
    var tags: [String]
    
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    Image("cursor-arrow-rays-white")
                        .frame(width: 24, height: 24)
                }
                .padding(5)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                Text(title)
                    .font(
                        Font.system(size: 24)
                            .weight(.medium)
                    )
                    .foregroundColor(.black)
            }
            .padding(0)
            
            Text(description)
                .font(Font.system(size: 13))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, minHeight: 15, maxHeight: 32, alignment: .topLeading)
            
            Text(id)
                .font(
                    Font.system(size: 13)
                        .weight(.medium)
                )
                .foregroundColor(.black.opacity(0.51))
            Divider()
            
            WrapLayout{
                ForEach(tags, id: \.self) { tag in
                    TagItem(text: tag, selectable: false)
                }
            }
        }
        .padding(20)
        .frame(width: 380, alignment: .topLeading)
        .background(.white)
        .cornerRadius(23)
        .shadow(color: .black.opacity(0.09), radius: 4.5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 23)
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)
        )
        .onHover { isHovered in
            self.isHovered = isHovered
        }
        .contextMenu {
            Button(action: {
                
                Data().updatePinned(id: self.id)
            }) {
                Text("Pin")
                Image(systemName: "pin")
            }
            
            Button(action: {
                // Handle report action
            }) {
                Text("Report")
                Image(systemName: "exclamationmark.bubble")
            }
        }
    }
}



struct CardSetList: View {
    @StateObject private var cardsViewModel = CardsViewModel()
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
            
                Text("Pinned")
                    .fontWeight(.semibold)
                    .padding(.leading, 30)
                    .font(.system(size: 40))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(cardsViewModel.pinnedSets) { set in
                    NavigationLink(destination: ContentView(ContentViewId: set.id)) {
                        CardItem(icon: "curlybraces.square", title: set.name, id: set.id, description: set.description, tags: set.tags)
                    }
                }
                
                Text("Featured")
                    .fontWeight(.semibold)
                    .padding(.leading, 30)
                    .font(.system(size: 40))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                ForEach(cardsViewModel.cards) { card in
                    if let pinnedSet = Data().getPinnedSet(), !pinnedSet.contains(card.id) {
                        NavigationLink(destination: ContentView(ContentViewId: card.id)) {
                            CardItem(icon: "curlybraces.square", title: card.name, id: card.id, description: card.description, tags: card.tags)
                        }
                    }
                }

            }
        }
    }
}

struct CardSetList_Previews: PreviewProvider {
    static var previews: some View {
        CardSetList()
    }
}
