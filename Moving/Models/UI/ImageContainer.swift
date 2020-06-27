//
// Created by Alex Dearden on 27/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class ImageContainer: UIImageView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    func loadImage(_ image: UIImage) {
        self.image = image
        label.isHidden = true
    }


    private func setup() {
        layer.cornerRadius = 7
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        contentMode = .scaleAspectFit
        setupLabel()
    }

    private func setupLabel() {
        addSubview(label)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to add image"

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Defaults.padding),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Defaults.padding),
        ])
    }
}

private extension ImageContainer {
    enum Defaults {
        static let padding: CGFloat = 24
    }
}
