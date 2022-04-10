//
//  StorageManager.swift
//  Places
//
//  Created by Алексей Моторин on 08.04.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject (_ place: Places) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject (_ place: Places) {
        try! realm.write {
            realm.delete(place)
        }
        
    }
}
