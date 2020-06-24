//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation

protocol Persistenceable {
    func storeRoom(room: Room)
    func storeRooms(rooms: [Room])
    func retrieveRooms() -> [Room]
    func storeItem(item: Item, for room: Room)
    func storeItem(items: [Item], for room: Room)
    func retrieveItems(for room: Room) -> [Item]
}

class PersistenceManager: Persistenceable {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func storeRoom(room: Room) {
        if let encoded = try? encoder.encode(room) {
            defaults.set(encoded, forKey: Key.room)
        }
    }

    func storeRooms(rooms: [Room]) {
        if let encoded = try? encoder.encode(rooms) {
            defaults.set(encoded, forKey: Key.rooms)
        }
    }

    func storeItem(item: Item, for room: Room) {
        if let encoded = try? encoder.encode(item) {
            defaults.set(encoded, forKey: Key.item)
        }
    }

    func storeItem(items: [Item], for room: Room) {
        if let encoded = try? encoder.encode(items) {
            defaults.set(encoded, forKey: Key.items)
        }
    }

    func retrieveRooms() -> [Room] {
        if let rooms = defaults.object(forKey: Key.rooms) as? Data {
            if let loadedRooms = try? decoder.decode([Room].self, from: rooms) {
                return loadedRooms
            }
        }

        return []
    }

    func retrieveItems(for room: Room) -> [Item] {
        if let items = defaults.object(forKey: Key.items) as? Data {
            if let loadedItems = try? decoder.decode([Item].self, from: items) {
                return loadedItems
            }
        }

        return []

    }

    private enum Key {
        static let room = "savedRoom"
        static let item = "savedItem"
        static let rooms = "savedRooms"
        static let items = "savedItems"
    }
}

