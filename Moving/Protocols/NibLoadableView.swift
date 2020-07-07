//
// Created by Alex Dearden on 07/07/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadableView: class {
    static var nibName: String { get }
    static func instantiate() -> Self
    static func instantiate(nibName: String) -> Self
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }

    static func instantiate() -> Self {
        return instantiate(nibName: nibName)
    }

    static func instantiate(nibName: String) -> Self {
        return UINib(nibName: nibName, bundle: Bundle(for: Self.self))
            .instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}