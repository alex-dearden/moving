//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import SwiftUI

struct Room: Identifiable {
    let id: UUID = UUID()
    var name: String
    var order: Int
    var type: RoomType

    enum RoomType {
        case bedroom
        case livingRoom
        case kitchen
        case diningRoom
        case bathroom
        case office
        case other

        var name: String {
            switch self {
            case .livingRoom:
                return "Living Room"
            case .diningRoom:
                return "Dining Room"
            default:
                return String(describing: self).capitalized
            }
        }

        var icon: Image {
            switch self {
            case .livingRoom:
                return Image(systemName: "airpods")
            case .bedroom:
                return Image(systemName: "xmark.icloud")
            case .kitchen:
                return Image(systemName: "macpro.gen3.server")
            default:
                return Image(systemName: "livephoto")
            }
        }
    }
}
