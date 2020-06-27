//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import Combine

protocol Storable {
    var rooms: [Room] { get set }
    func addRoom(_ room: Room)
    func deleteRoom(at index: Int)
    func moveRoom(from source: IndexSet, to destination: Int)
    func addItem(_ item: Item, in room: Room)
    func deleteItem(at offset: IndexSet, in room: Room)
}

class RoomStore: ObservableObject, Storable {
    @Published var rooms: [Room] = []

    private let persistenceManager: Persistenceable = PersistenceManager()

    enum StoreError: Error {
        case roomNotFoundById
        case itemNotFoundById
    }

    init() {
        rooms = persistenceManager.retrieveRooms()
    }

    func addRoom(_ room: Room) {
        rooms.append(room)
        persistRooms()
    }

    func deleteRoom(at index: Int) {
        rooms.remove(at: index)

        persistRooms()
    }

    func moveRoom(from source: IndexSet, to destination: Int) {
        // TODO: We need to implement this on this class' array
//        rooms.move(fromOffsets: source, toOffset: destination)

        persistRooms()
    }

    func addItem(_ item: Item, in room: Room) {
        guard let roomIndex = try? findRoom(with: room.id) else {
            return
        }

        rooms[roomIndex].items.append(item)

        persistRooms()
    }

    func deleteItem(at offset: IndexSet, in room: Room) {
        guard var roomIndex = try? findRoom(with: room.id) else {
            return
        }

        rooms[roomIndex].items.remove(atOffsets: offset)

        persistRooms()
    }
}

// MARK: Private methods

private extension RoomStore {
    func findRoom(with id: UUID) throws -> Int {
        guard let roomIndex = (rooms.firstIndex { foundRoom in
            return foundRoom.id == id
        }) else {
            assertionFailure("Room with id not found!")
            throw StoreError.roomNotFoundById
        }

        return roomIndex
    }

    func persistRooms() {
        persistenceManager.storeRooms(rooms: rooms)
    }
}

// Only used for SwiftUI previews
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
