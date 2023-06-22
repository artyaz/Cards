//
//  CardSetList.swift
//  Cards
//
//  Created by Артем Чмиленко on 22.06.2023.
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
            .frame(width: 400, height: 150)
            .shadow(color: Color.black, radius: 1, x: 0, y: 0)
            .padding(.top, 10.0)
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
    }
}



struct CardSetList: View {
    @StateObject private var cardsViewModel = CardsViewModel()
    var body: some View {
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
    }
}

struct CardSetList_Previews: PreviewProvider {
    static var previews: some View {
        CardSetList()
    }
}
