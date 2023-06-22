//
//  CardsHub.swift
//  Cards
//
//  Created by Артем Чмиленко on 15.06.2023.
//

import SwiftUI

struct CardsHub: View {
    @State private var showActions = false
    
    var body: some View {
        ZStack {
            CardSetList()
            if showActions {
                    Color.white.opacity(0.8).ignoresSafeArea().blur(radius: 2)
                        .onTapGesture {
                            withAnimation() {
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
                            .transition(.move(edge: .bottom))
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
