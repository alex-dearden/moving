//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import  UIKit

struct Item: Identifiable, Codable, Listable {
    let id: UUID = UUID()
    var name: String
    var order: Int
    var type: ItemType
    var image: CodableImage?
    var checked: Bool = false
}

struct CodableImage: Codable {
    let imageData: Data?

    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getCodableImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)

        return image
    }
}

extension Item: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

enum ItemType: String, CaseIterable {
    case ps4, ps4Controller, tv, microwave, pots, cutlery, glasses, plates, table, chair, bed, clothes, nightstand,
         bicycle, book, comic, keyboard, trackpad, mouse, tablet, ipad, iphone, sheets, other

    var name: String {
        return String(describing: self)
    }

    static var all: [String] {
        let sortedArray = ItemType.allCases.map { $0.name }.sorted()
        return sortedArray
    }
}

extension ItemType {
    enum CodingKeys: CodingKey {
        case ps4, ps4Controller, tv, microwave, pots, cutlery, glasses, plates, table, chair, bed, clothes, nightstand,
             bicycle, book, comic, keyboard, trackpad, mouse, tablet, ipad, iphone, sheets, other
    }
}

extension ItemType: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .ps4:
            try container.encode(true, forKey: .ps4)
        case .ps4Controller:
            try container.encode(true, forKey: .ps4Controller)
        case .tv:
            try container.encode(true, forKey: .tv)
        case .microwave:
            try container.encode(true, forKey: .microwave)
        case .pots:
            try container.encode(true, forKey: .pots)
        case .cutlery:
            try container.encode(true, forKey: .cutlery)
        case .glasses:
            try container.encode(true, forKey: .glasses)
        case .plates:
            try container.encode(true, forKey: .plates)
        case .table:
            try container.encode(true, forKey: .table)
        case .chair:
            try container.encode(true, forKey: .chair)
        case .bed:
            try container.encode(true, forKey: .bed)
        case .clothes:
            try container.encode(true, forKey: .clothes)
        case .nightstand:
            try container.encode(true, forKey: .nightstand)
        case .bicycle:
            try container.encode(true, forKey: .bicycle)
        case .book:
            try container.encode(true, forKey: .book)
        case .comic:
            try container.encode(true, forKey: .comic)
        case .keyboard:
            try container.encode(true, forKey: .keyboard)
        case .trackpad:
            try container.encode(true, forKey: .trackpad)
        case .mouse:
            try container.encode(true, forKey: .mouse)
        case .tablet:
            try container.encode(true, forKey: .tablet)
        case .ipad:
            try container.encode(true, forKey: .ipad)
        case .iphone:
            try container.encode(true, forKey: .iphone)
        case .sheets:
            try container.encode(true, forKey: .sheets)
        case .other:
            try container.encode(true, forKey: .other)
        }
    }
}

extension ItemType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .ps4:
            self = .ps4
        case .ps4Controller:
            self = .ps4Controller
        case .tv:
            self = .tv
        case .microwave:
            self = .microwave
        case .pots:
            self = .pots
        case .cutlery:
            self = .cutlery
        case .glasses:
            self = .glasses
        case .plates:
            self = .plates
        case .table:
            self = .table
        case .chair:
            self = .chair
        case .bed:
            self = .bed
        case .clothes:
            self = .clothes
        case .nightstand:
            self = .nightstand
        case .bicycle:
            self = .bicycle
        case .book:
            self = .book
        case .comic:
            self = .comic
        case .keyboard:
            self = .keyboard
        case .trackpad:
            self = .trackpad
        case .mouse:
            self = .mouse
        case .tablet:
            self = .tablet
        case .ipad:
            self = .ipad
        case .iphone:
            self = .iphone
        case .sheets:
            self = .sheets
        case .other:
            self = .other
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unable to decode enum."
                )
            )
        }
    }
}