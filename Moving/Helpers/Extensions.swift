//
// Created by Alex Dearden on 16/07/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}