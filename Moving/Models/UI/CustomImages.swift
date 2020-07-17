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

    func setState(state: CellState) {
        image = state.image
    }

    private func commonInit() {
        image = CellState.unchecked.image
    }
}