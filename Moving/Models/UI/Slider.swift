//
// Created by Alex Dearden on 25/07/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class Slider: UISlider {

    // Custom thumb view which will be converted to UIImage
    // and set as thumb. You can customize it's colors, border, etc.
    private lazy var thumbView: UIView = {
        let thumb = UIView()
//        thumb.backgroundColor = .yellow //thumbTintColor
        thumb.layer.borderWidth = 0
        thumb.layer.borderColor = UIColor.darkGray.cgColor
        return thumb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        let thumbRadius: CGFloat = 0
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
    }

    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb

        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2

        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        let trackHeight: CGFloat = 3
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight

        return newRect
    }

}