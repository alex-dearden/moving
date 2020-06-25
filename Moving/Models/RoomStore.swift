//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import Combine

class RoomStore: ObservableObject {
    @Published var rooms: [Room] = []

    private let persistenceManager: Persistenceable = PersistenceManager()

    init() {
        rooms = persistenceManager.retrieveRooms()
    }

    func saveRoom(_ room: Room) {
        rooms.append(room)

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
