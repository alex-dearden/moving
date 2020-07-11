//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import Combine

protocol Storable {
    var rooms: [Room] { get set }
    func addRoom(_ room: Room)
    func editRoom(_ room: Room)
    func deleteRoom(at index: Int)
    func moveRoom(from source: IndexSet, to destination: Int)
    func addItem(_ item: Item, in room: Room)
    func editItem(_ item: Item, in room: Room)
    func deleteItem(at offset: IndexSet, in room: Room)
}

class RoomStore: ObservableObject, Storable {
    @Published var rooms: [Room] = []
    @Published var itemsForRoom: [Item] = []

    private let persistenceManager: Persistenceable = PersistenceManager()

    enum StoreError: Error {
        case roomNotFoundById
        case itemNotFoundById
    }

    init() {
        rooms = persistenceManager.retrieveRooms()
    }

    func update(for room: Room) {
        guard let roomIndex = try? findRoom(with: room.id) else {
            return
        }

        updateItemsArray(in: roomIndex)
    }

    func addRoom(_ room: Room) {
        rooms.append(room)
        persistRooms()
    }

    func editRoom(_ room: Room) {
        guard let roomIndex = try? findRoom(with: room.id) else {
            return
        }

        rooms[roomIndex].name = room.name
        rooms[roomIndex].type = room.type

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
        updateItemsArray(in: roomIndex)
    }

    func editItem(_ item: Item, in room: Room) {
        guard let roomIndex = try? findRoom(with: room.id),
            let itemIndex = try? findItem(with: item.id, in: room) else {
            return
        }

        rooms[roomIndex].items[itemIndex].name = item.name
        rooms[roomIndex].items[itemIndex].type = item.type

        persistRooms()
        updateItemsArray(in: roomIndex)
    }

    func deleteItem(at offset: IndexSet, in room: Room) {
        guard var roomIndex = try? findRoom(with: room.id) else {
            return
        }

        rooms[roomIndex].items.remove(atOffsets: offset)

        persistRooms()
        updateItemsArray(in: roomIndex)
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

    func findItem(with id: UUID, in room: Room) throws -> Int {
        guard let itemIndex = (room.items.firstIndex { foundItem in
            return foundItem.id == id
        }) else {
            assertionFailure("Item with id not found.")
            throw StoreError.itemNotFoundById
        }

        return itemIndex
    }

    func persistRooms() {
        persistenceManager.storeRooms(rooms: rooms)
    }

    func updateItemsArray(in roomIndex: Int) {
        itemsForRoom = rooms[roomIndex].items
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
