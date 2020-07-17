//
// Created by Alex Dearden on 27/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

protocol ImageTappedDelegate: class {
    func wasTapped()
}

class ImageContainer: UIImageView {

    weak var tapDelegate: ImageTappedDelegate?

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    func loadImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }

        layer.borderWidth = 0
        self.image = image
        label.isHidden = true
    }


    private func setup() {
        layer.cornerRadius = 7
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        contentMode = .scaleAspectFit
        setupLabel()
        setupTapGesture()
    }

    private func setupLabel() {
        addSubview(label)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Defaults.labelText
        label.textColor = UIColor(named: Identifiers.Color.cellBackground) // TODO: Change this Identifier returns UIColor, UIImage, etc

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Defaults.padding),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Defaults.padding),
        ])
    }
}

// MARK: Tap gesture
private extension ImageContainer {
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(wasTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    @objc func wasTapped() {
        tapDelegate?.wasTapped()
    }
}

private extension ImageContainer {
    enum Defaults {
        static let padding: CGFloat = 24
        static let labelText = "Tap to add image"
    }
}
