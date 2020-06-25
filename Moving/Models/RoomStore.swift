//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import Combine

protocol Storable {
    var rooms: [Room] { get set }
    func save(room: Room)
    func delete(room: Room)
    func saveItem(_ item: Item, in room: Room)
    func deleteItem(_ item: Item, in room: Room)
}

class RoomStore: ObservableObject, Storable {
    @Published var rooms: [Room] = []

    private let persistenceManager: Persistenceable = PersistenceManager()

    init() {
        rooms = persistenceManager.retrieveRooms()
    }

    func save(room: Room) {
        rooms.append(room)
        persistRooms()
    }

    func delete(room: Room) {
        rooms.removeAll { foundRoom in
            foundRoom.name == room.name
        }

        persistRooms()
    }

    func saveItem(_ item: Item, in room: Room) {
        guard var itemRoom = findRoom(with: room.id) else {
            return
        }
        itemRoom.items.append(item)

        persistRooms()
    }

    func deleteItem(_ item: Item, in room: Room) {
        guard var itemRoom = findRoom(with: room.id) else {
            return
        }

        itemRoom.items.removeAll { foundItem in
            foundItem.id == item.id
        }
    }

    // MARK: Private methods

    private func findRoom(with id: UUID) -> Room? {
        guard var itemRoom = (rooms.filter { foundRoom in
            return foundRoom.id == id
        }.first) else {
            return nil
        }

        return itemRoom
    }

    private func persistRooms() {
        persistenceManager.storeRooms(rooms: rooms)
    }
}

class TestRooms: RoomStore {
    override init() {
        super.init()

        rooms = [
            Room(name: "Bedroom", order: 1, type: .bedroom),
            Room(name: "Bathroom", order: 2, type: .bathroom),
            Room(name: "TV Room", order: 3, type: .livingRoom)
        ]
    }
}
