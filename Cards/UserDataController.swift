//
//  UserDataController.swift
//  Cards
//
//  Created by Артем Чмиленко on 25.06.2023.
//

import Foundation

class Data {
    var pinnedSets: [String]?
    
    func loadDefaults() {
        if let loadedPinnedSets = UserDefaults.standard.array(forKey: "PinnedSets") as? [String] {
            pinnedSets = loadedPinnedSets
        }
    }
    
    func saveDefaults() {
        UserDefaults.standard.set(pinnedSets, forKey: "PinnedSets")
    }
    
    func updatePinned(id: String) {
        loadDefaults()
        if var unwrappedPinnedSets = pinnedSets {
            pinnedSets?.append(id)
        } else {
            pinnedSets = [id]
        }
        saveDefaults()
    }
    
    func getPinnedSet () -> [String]? {
        loadDefaults()
        guard let unwarpedPinnedSets = pinnedSets else { return [] }
        
        return unwarpedPinnedSets
    }

}
