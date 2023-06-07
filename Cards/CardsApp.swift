//
//  CardsApp.swift
//  Cards
//
//  Created by Артем Чмиленко on 07.06.2023.
//

import SwiftUI
import Firebase

@main
struct CardsApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

