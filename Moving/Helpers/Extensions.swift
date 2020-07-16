//
// Created by Alex Dearden on 16/07/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}

extension Optional where Wrapped == UIImage {
    func codableImage() -> CodableImage? {
        guard let currentImage = self else {
            return nil
        }

        return CodableImage(withImage: currentImage)
    }
}