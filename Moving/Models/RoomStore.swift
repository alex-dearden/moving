//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import Combine

class RoomStore: ObservableObject {
    @Published var rooms: [Room]

    init() {
        self.rooms = TestRooms().rooms
    }
}

struct TestRooms {
    let rooms: [Room] = [
        Room(name: "Bedroom", order: 1, type: .bedroom),
        Room(name: "Bathroom", order: 2, type: .bathroom),
        Room(name: "TV Room", order: 3, type: .livingRoom)
    ]
}