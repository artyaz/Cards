//
//  AICardsCreationScreen.swift
//  Cards
//
//  Created by Артем Чмиленко on 22.06.2023.
//

import SwiftUI
import WrapLayout

struct AICardsCreationScreen: View {
    
    @State private var textField1: String = ""
    @State private var textField2: String = ""
    @State private var selectedTags: [String] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 41) {
            HStack(alignment: .center, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    Image("sparkles")
                      .frame(width: 24, height: 24)
                }
                .padding(5)
                .background(Constants.primaryBlue)
                .cornerRadius(10)
                .overlay(
                  RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Constants.primaryDarkBlue, lineWidth: 1)
                )
                
                Text("Create with AI")
                  .font(
                    Font.system(size: 32)
                      .weight(.semibold)
                  )
                  .foregroundColor(.black)
                
            }
            .padding(0)
            
            Divider()
                VStack(alignment: .center, spacing: 26) {
                    //text input
                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $textField1)
                    .padding(10)
                    .frame(width: 340, height: 47, alignment: .leading)
                    .cornerRadius(10)
                    .overlay(
                      RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(.black, lineWidth: 1)
                    )
                    
                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $textField2)
                    .padding(15)
                    .frame(width: 340, height: 131, alignment: .topLeading)
                    .cornerRadius(10)
                    .overlay(
                      RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(.black, lineWidth: 1)
                    )
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select tags")
                          .font(
                            Font.system(size: 12)
                              .weight(.semibold)
                          )
                          .foregroundColor(.black.opacity(0.65))
                        
                        WrapLayout() {
                            ForEach(tagDict.sorted(by: <), id: \.key) { key, value in
                                TagItem(text: key, selectable: true) { text, isSelected in
                                            if isSelected {
                                                selectedTags.append(text)
                                            } else {
                                                selectedTags.removeAll { $0 == text }
                                            }
                                        }
                                }
                            
                            
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(15)
                    .frame(width: 335, alignment: .topLeading)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                    .cornerRadius(10)
                    .overlay(
                      RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(.black, lineWidth: 1)
                    )
                    
                }
                .padding(0)
            
            VStack(alignment: .leading, spacing: 10) {
                Button("Create") {
                    
                }
                .padding(.horizontal, 107)
                .padding(.vertical, 10)
                .background(.black)
                .foregroundColor(.white)
                .fontWeight(.medium)
                .cornerRadius(10)
            }
            .padding(.horizontal, 45)
            .padding(.vertical, 0)
            
            }
            .padding(0)
    }
    
}

struct AICardsCreationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AICardsCreationScreen()
    }
}
