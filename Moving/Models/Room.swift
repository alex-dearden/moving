//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import SwiftUI

enum RoomType: CaseIterable {
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
            return Image(systemName: "film")
        case .bedroom:
            return Image(systemName: "xmark.icloud")
        case .kitchen:
            return Image(systemName: "gauge")
        default:
            return Image(systemName: "livephoto")
        }
    }
}

extension RoomType {
    enum CodingKeys: CodingKey {
        case  bedroom, livingRoom, kitchen, diningRoom, bathroom, office, other
    }
}

extension RoomType: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .bedroom:
            try container.encode(true, forKey: .bedroom)
        case .livingRoom:
            try container.encode(true, forKey: .livingRoom)
        case .kitchen:
            try container.encode(true, forKey: .kitchen)
        case .diningRoom:
            try container.encode(true, forKey: .diningRoom)
        case .bathroom:
            try container.encode(true, forKey: .bathroom)
        case .office:
            try container.encode(true, forKey: .office)
        case .other:
            try container.encode(true, forKey: .other)
        }
    }
}

extension RoomType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .bedroom:
            self = .bedroom
        case .livingRoom:
            self = .livingRoom
        case .kitchen:
            self = .kitchen
        case .diningRoom:
            self = .diningRoom
        case .bathroom:
            self = .bathroom
        case .office:
            self = .office
        case .other:
            self = .other
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
}


struct Room: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var order: Int
    var type: RoomType
    var items: [Item] = []

    // In order to use this, we would need to delete the room from roomstore.rooms, modify it and readd it
    // And that would fuck the order up, unless we preserve it
/*
    mutating func add(item: Item) {
        items.append(item)
    }
*/
}
