//
//  CardsHub.swift
//  Cards
//
//  Created by Артем Чмиленко on 15.06.2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class apiCalls{
    func generateCardSet(name: String, qc: Int){
        let url = URL(string: "https://cards-backend-python-91217e25d432.herokuapp.com/generate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "name": name,
            "questions_count": qc
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
    
    private var db = Firestore.firestore()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
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
}

struct CardListItem: Identifiable, Codable {
    var id: String
    var cardSets: [[String: String]]
    var name: String
    var ownerID: String
    var tags: [String]
}

struct CardItem: View {
    var icon: String
    var title: String
    var id: String
    var description: String
    

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(width: 350, height: 150)
            .overlay(
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                        
                        Text(title)
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(id)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text(description)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
                }
                .padding()
            )
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 0)
            .hoverEffect(.highlight)
    }
}

struct CardsHub: View {
    @StateObject private var cardsViewModel = CardsViewModel()
    @State private var showActions = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    HStack() {
                        Text("Featured")
                            .fontWeight(.semibold)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 40))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    LazyVStack {
                        ForEach(cardsViewModel.cards) { card in
                            NavigationLink(destination: ContentView(ContentViewId: card.id)) {
                                CardItem(icon: "curlybraces.square", title: card.name, id: card.id, description: "test")
                            }
                        }
                    }
                }
            }
            if showActions {
                    Color.white.opacity(0.8).ignoresSafeArea().blur(radius: 2)
                        .onTapGesture {
                            withAnimation {
                                showActions = false
                            }
                        }
                    VStack {
                                Button(action: {
                                    // Action 1
                                }) {
                                    Text("🖋️").font(Font.system(size: 40))
                                    Text("Create Card Set")
                                        .fontWeight(.bold)
                                        .font(Font.system(size: 25))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black) // Text color
                                }
                                .scaleEffect(showActions ? 1 : 0)
                                .animation(Animation.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.5))

                                Button(action: {
                                    withAnimation {
                                        self.showActions.toggle()
                                    }
                                }) {
                                    Text("🦄").font(Font.system(size: 40))
                                    Text("Create with AI")
                                        .fontWeight(.bold)
                                        .font(Font.system(size: 25))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black) // Text color
                                }
                                .scaleEffect(showActions ? 1 : 0)
                                .animation(Animation.spring(response: 0.49, dampingFraction: 0.29, blendDuration: 0.49))
                            }
                            .transition(.move(edge: .bottom)) // Add this line
                        }


            Button(action: {
                    withAnimation() { // Modify this line
                        showActions.toggle()
                    }
                }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(40)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                    .padding()
                    .position(x: 50, y: UIScreen.main.bounds.height - 110) // Position bottom left
                }
    }
}
struct CardsHub_Previews: PreviewProvider {
    static var previews: some View {
        CardsHub()
    }
}
