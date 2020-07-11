//
// Created by Alex Dearden on 11/07/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 12
        titleLabel?.font = UIFont(name: "CourierNewPS-BoldMT", size: 18)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 96),
            heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}

class CancelButton: RoundedButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor(named: Identifiers.Color.cancelButtonBackground)
        setTitle("Cancel", for: .normal)
        setTitleColor(UIColor(named: Identifiers.Color.cancelText), for: .normal)
    }
}

class AddButton: RoundedButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor(named: Identifiers.Color.buttonBackground)
        setTitle("Add", for: .normal)
        setTitleColor(UIColor(named: Identifiers.Color.buttonText), for: .normal)
    }
}