//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation

struct Item: Identifiable {
    let id: UUID = UUID()
    var name: String
    var order: Int
    var room: Room
}
