//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import  UIKit

struct Item: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var order: Int
    var image: CodableImage?
}

struct CodableImage: Codable {
    let imageData: Data?

    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)

        return image
    }
}

enum ItemType: CaseIterable {
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