//
// Created by Alex Dearden on 16/07/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class SwitchImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    func setImage(on: Bool) {
        image = on ? Defaults.onImage : Defaults.offImage
        debugPrint("image should be:", image)
    }

    private func commonInit() {
        image = Defaults.offImage
    }

    private enum Defaults {
        static let onImage = UIImage(named: Identifiers.Image.switchOn)
        static let offImage = UIImage(named: Identifiers.Image.switchOff)
    }
}