//
//  AICardsCreationScreen.swift
//  Cards
//
//  Created by Артем Чмиленко on 22.06.2023.
//

import SwiftUI

struct AICardsCreationScreen: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack(alignment: .top, spacing: 10) {
                Text("Create card set")
                    .font(Font.system(size: 40))
                    .bold()
                    .foregroundColor(.black)
                Spacer()
            }
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(10)
                .frame(width: 335)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.50)
                        .stroke(.black, lineWidth: 0.50)
                )
            
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(10)
                .frame(width: 335)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.50)
                        .stroke(.black, lineWidth: 0.50)
                )
            HStack(alignment: .center) {
                Spacer()
                Button("Create") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }
                    .padding(EdgeInsets(top: 10, leading: 107, bottom: 10, trailing: 107))
                    .background(.black)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .cornerRadius(10)

                Spacer()
            }
            Spacer()
            
        }
        .padding(EdgeInsets(top: 50, leading: 25, bottom: 50, trailing: 25))
        .frame(width: 385, height: 844)
    }
}

struct AICardsCreationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AICardsCreationScreen()
    }
}
