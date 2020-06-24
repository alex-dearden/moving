//
// Created by Alex Dearden on 24/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation

protocol Listable {
    var id: UUID { get }
    var name: String { get set }
    var order: Int { get set }
}
