//
//  FloatingButton.swift
//  Cards
//
//  Created by Артем Чмиленко on 24.06.2023.
//

import SwiftUI

struct FloatingButton: View {
    
    @State private var showActions = false
    @State private var isTapped = true
    @State private var shouldRotate = false
    @State private var shouldShowAICardsCreationScreen = false
    
    var body: some View {
        if showActions {
            Color.white
                .offset(y: isTapped ? 200 : 0)
                .opacity(isTapped ? 0 : 0.8)
                .animation(.easeOut(duration: 0.1))
                .scaleEffect(showActions ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.5))
                .ignoresSafeArea()
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                    self.isTapped.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation{
                            self.showActions.toggle()
                            self.shouldRotate.toggle()
                        }
                    }
                }
            VStack {
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                    self.shouldShowAICardsCreationScreen = true
                }) {
                    Text("🖋️").font(Font.system(size: 40))
                    Text("Create Card Set")
                        .fontWeight(.bold)
                        .font(Font.system(size: 25))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black) // Text color
                }
                .sheet(isPresented: $shouldShowAICardsCreationScreen, content: {
                    AICardsCreationScreen()
                })
                .offset(y: isTapped ? 200 : 0)
                .opacity(isTapped ? 0 : 1)
                .animation(.easeOut(duration: 0.1))
                .scaleEffect(showActions ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.5))
                
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                    self.isTapped.toggle()
                    withAnimation {
                        self.showActions.toggle()
                        self.shouldRotate.toggle()
                    }
                }) {
                    Text("🦄").font(Font.system(size: 40))
                    Text("Create with AI")
                        .fontWeight(.bold)
                        .font(Font.system(size: 25))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black) // Text color
                }
                .offset(y: isTapped ? 200 : 0)
                .opacity(isTapped ? 0 : 1)
                .animation(.easeOut(duration: 0.1))
                .scaleEffect(showActions ? 1 : 0)
                .animation(Animation.spring(response: 0.49, dampingFraction: 0.29, blendDuration: 0.49))
            }
            .transition(.move(edge: .bottom))
        }
        
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
            
            if showActions == false {
                withAnimation() { // Modify this line
                    showActions.toggle()
                    isTapped.toggle()
                    shouldRotate.toggle()
                }
            } else {
                isTapped.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation{
                        showActions.toggle()
                        shouldRotate.toggle()
                    }
                }
            }
            
            
            
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .cornerRadius(40)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .inset(by: 0.5)
                        .stroke(.black, lineWidth: 1)
                )
                .rotationEffect(Angle(degrees: shouldRotate ? 45 : 0))
                .animation(Animation.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.5), value: shouldRotate)
        }
        .padding()
        .position(x: 50, y: UIScreen.main.bounds.height - 110) // Position bottom left
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton()
    }
}
