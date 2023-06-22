//
//  AICardsCreationScreen.swift
//  Cards
//
//  Created by Артем Чмиленко on 22.06.2023.
//

import SwiftUI

struct AICardsCreationScreen: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            TextField("Placeholder", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            Button("Done") {
                        
            }
        }
        
    }
}

struct AICardsCreationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AICardsCreationScreen()
    }
}
