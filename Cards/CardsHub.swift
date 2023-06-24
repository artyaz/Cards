//
//  CardsHub.swift
//  Cards
//
//  Created by Артем Чмиленко on 15.06.2023.
//

import SwiftUI

struct CardsHub: View {
    
    
    var body: some View {
        NavigationView {
            ZStack {
                CardSetList()
                FloatingButton()
            }
        }
    }
}
struct CardsHub_Previews: PreviewProvider {
    static var previews: some View {
        CardsHub()
    }
}
