//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import Combine

class RoomStore: ObservableObject {
    @Published var rooms: [Room]

    init() {

    }
}
