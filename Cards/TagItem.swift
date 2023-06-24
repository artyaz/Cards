//
//  TagItem.swift
//  Cards
//
//  Created by Артем Чмиленко on 24.06.2023.
//

import SwiftUI

var tagDict = ["programming": "code-bracket-square", "game": "cube", "data": "wallet", "develop": "cursor-arrow-rays", "hardware": "cpu-chip", "finances": "building-library", "task-managment": "calendar", "security": "key", "analytics": "chart-bar"]

struct TagItem: View {
    var text: String
    var selectable: Bool
    var onSelectionChange: ((String, Bool) -> Void)? // Callback function
    @State private var isSelected: Bool = false
    @GestureState private var isPressed: Bool = false
    
    init(text: String, selectable: Bool, onSelectionChange: ((String, Bool) -> Void)? = nil) {
        self.text = text
        self.selectable = selectable
        self.onSelectionChange = onSelectionChange
        self._isSelected = State(initialValue: !selectable)
    }

    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(tagDict[text]!)
              .frame(width: 18, height: 18)
            
            Text(text)
              .font(
                Font.system(size: 12)
                  .weight(.medium)
              )
              .foregroundColor(isSelected ?Color(red: 0.16, green: 0.39, blue: 0.74) : Color.black)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(isSelected ? Constants.primaryBlue : Color.white)
        .cornerRadius(9.72414)
        .shadow(color: Color(red: 0.16, green: 0.39, blue: 0.74).opacity(0.3), radius: 3.5, x: 0, y: 1)
        .overlay(
          RoundedRectangle(cornerRadius: 9.72414)
            .inset(by: 0.5)
            .stroke(isSelected ? Constants.primaryDarkBlue : Constants.primaryBlack, lineWidth: 1)
        )
        .scaleEffect(isPressed ? 1.1 : 1)
        .animation(.spring(), value: isPressed)
        .onTapGesture {
                if selectable {
                    isSelected.toggle()
                    if isSelected {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    onSelectionChange?(text, isSelected) // Call the callback function
                }
            }
        .simultaneousGesture(LongPressGesture().updating($isPressed) { currentState, gestureState, transaction in
            gestureState = currentState
        })
    }
}

struct TagItem_Previews: PreviewProvider {
    static var previews: some View {
        TagItem(text: "programming", selectable: true)
    }
}
