//
// Created by Alex Dearden on 20/07/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class GraphCircle: UIView {

    private var endArc: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    private var arcWidth: CGFloat = 2.0
    private var arcColor = UIColor.white.cgColor
    private var arcBackgroundColor = UIColor.red.cgColor
    private var rectangle: CGRect!

    func update(for percentage: Double, in frame: CGRect) {
        endArc = CGFloat(percentage)
        rectangle = frame
        drawCircle()
    }

    private func drawCircle() {
        guard let rectangle = rectangle else {
            assertionFailure("No rectangle found")
            return
        }

//        let fullCircle: CGFloat = 2.0 * .pi
//        let start = -0.25 * fullCircle
//        let end: CGFloat = endArc * fullCircle + start

        //find the centerpoint of the rect
//        let centerPoint = CGPoint(x: rectangle.midX, y: rectangle.midY)

        //define the radius by the smallest side of the view
//        var radius: CGFloat = (rectangle.width - arcWidth) / 2.0


        let renderer = UIGraphicsImageRenderer(size: CGSize(width: rectangle.width, height: rectangle.height))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            ctx.cgContext.setLineWidth(3)

            let rectangle = CGRect(x: 0, y: 0, width: rectangle.width, height: rectangle.height)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }



//
//        //starting point for all drawing code is getting the context.
//        let context = UIGraphicsGetCurrentContext()
//        //set colorspace
//        let colorspace = CGColorSpaceCreateDeviceRGB()
//        //set line attributes
//        context?.setLineWidth(arcWidth)
//        context?.setLineCap(.round)
//
//        //make the circle background
//        context?.setStrokeColor(arcBackgroundColor)
//        context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
//        context?.strokePath()
//
//        //draw the arc
//        context?.setStrokeColor(arcColor)
//        context?.setLineWidth(arcWidth * 0.8)
//        context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
//        context?.strokePath()
    }
}
