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

class CardsViewModel: ObservableObject {
    @Published var cards = [CardListItem]()
    
    private var db = Firestore.firestore()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        db.collection("cards").limit(to: 20).addSnapshotListener { (querySnapshot, error) in
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
    
    var body: some View {
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
                    CardItem(icon: "multiply.circle.fill", title: card.name, id: card.id, description: "test")
                }
            }
        }
    }

}

struct CardsHub_Previews: PreviewProvider {
    static var previews: some View {
        CardsHub()
    }
}
