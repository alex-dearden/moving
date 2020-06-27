//
// Created by Alex Dearden on 27/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class ImageContainer: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        layer.cornerRadius = 7
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
    }
}
