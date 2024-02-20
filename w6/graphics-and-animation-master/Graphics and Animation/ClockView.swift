//
//  ClockView.swift
//  Graphics and Animation
//
//  Created by Richard Telford on 2/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

class ClockView: UIView {
      override class var layerClass : AnyClass {
            return ClockLayer.self
        }
        
    }

    class ClockLayer : CALayer, CALayerDelegate {
        var hand : CALayer?
        
        override func layoutSublayers() {
            self.setup()
        }
        
        /*  This drawing has 4 sublayers in the view.  They get painted in this order:
         - The background, which is a gradient-colored square and uses CAGradientLayer
         - The circle, which is the face of the compass, and uses CAShapeLayer
         - The points on the clock, which is text, and uses CATextLayer
         - The hand, which is a CALayer we draw ourselves.
         */
        
        func setup () {
            // Paint the background in gradient color
            let g = CAGradientLayer()
            g.contentsScale = UIScreen.main.scale
            g.frame = self.bounds
            g.colors = [
                UIColor.blue.cgColor,
                UIColor.green.cgColor,
                UIColor.yellow.cgColor
            ]
            g.locations = [0.0, 0.5, 1.0]
            self.addSublayer(g)
            
            // Draw the dial on the clock
            let circle = CAShapeLayer()
            circle.contentsScale = UIScreen.main.scale
            circle.lineWidth = 2.0
            circle.fillColor = UIColor(red:0.8, green:0.8, blue:0.8, alpha:0.6).cgColor
            circle.strokeColor = UIColor.gray.cgColor
            let p = CGMutablePath()
            p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
            circle.path = p
            self.addSublayer(circle)
            circle.bounds = self.bounds
            circle.position = self.bounds.center
            
            // Use some Unicode characters for the numbers on the dial
             let pts = "ⅫⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪ"
            // Use some Unicode characters for the numbers on the dial
            //let pts = "🕛🕐🕐🕒🕓🕔🕕🕖🕗🕘🕙🕚"
            var ix = 0
            for c in pts {
                let t = CATextLayer()
                t.contentsScale = UIScreen.main.scale
                t.string = String(c)
                t.bounds = CGRect(x: 0,y: 0, width: 40, height: 40)
                t.position = circle.bounds.center
                let vert = circle.bounds.midY / t.bounds.height
                t.anchorPoint = CGPoint(x: 0.5, y: vert)
                t.alignmentMode = CATextLayerAlignmentMode.center
                t.foregroundColor = UIColor.black.cgColor
                t.setAffineTransform(CGAffineTransform(rotationAngle:CGFloat(ix) * .pi/6.0))
                circle.addSublayer(t)
                ix += 1
            }
            
            // Place the hour hand on the clock
            let hand = CALayer()
            hand.contentsScale = UIScreen.main.scale
            hand.bounds = CGRect(x: 0, y: 0, width: 50, height: 120)
            hand.position = self.bounds.center
            hand.anchorPoint = CGPoint(x: 0.5, y: 0.9)
            hand.delegate = self

            self.addSublayer(hand)
            hand.setNeedsDisplay()
            self.hand = hand
            self.handRotate360(duration: 15)
        }
        
        func handRotate360(duration: Double = 3) {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(Double.pi * 2)
            rotateAnimation.isRemovedOnCompletion = false
            rotateAnimation.duration = duration
            rotateAnimation.repeatCount = Float.infinity
            if let hand = self.hand {
                hand.add(rotateAnimation, forKey: "rotateViewAnimation")
            }
        }
        
        func draw(_ layer: CALayer, in con: CGContext) {
            // punch triangular hole in context clipping region
            con.move(to: CGPoint(x: 10, y: 120))
            con.addLine(to: CGPoint(x: 20, y: 110))
            con.addLine(to: CGPoint(x: 30, y: 120))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using: .evenOdd)
            
            // draw the vertical line, add its shape to the clipping region
            con.move(to: CGPoint(x: 20, y: 120))
            con.addLine(to: CGPoint(x: 20, y: 19))
            con.setLineWidth(20)
            con.setStrokeColor(UIColor.blue.cgColor)
            con.strokePath()
            
            // draw the triangle, the point of the hand.  First define an image (red and blue lines) that will be tiled in the layer using patternImage on a UIColor object.  Then use that pattern as the fill and draw the triangle inside a UIGraphicsPushContext.
            let r = UIGraphicsImageRenderer(size:CGSize(width: 6,height: 6))
            let stripes = r.image {
                ctx in
                let imcon = ctx.cgContext
                imcon.setFillColor(UIColor.blue.cgColor)
                imcon.fill(CGRect(x: 0, y: 0, width: 6, height: 6))
                imcon.setFillColor(UIColor.green.cgColor)
                imcon.fill(CGRect(x: 0, y: 0, width: 6,height: 4))
                imcon.setFillColor(UIColor.yellow.cgColor)
                imcon.fill(CGRect(x: 0,y: 0, width: 6, height: 2))
            }
            
            let stripesPattern = UIColor(patternImage:stripes)
            
            UIGraphicsPushContext(con)
            do {
                stripesPattern.setFill()
                let p = UIBezierPath()
                p.move(to:CGPoint(x: 0, y: 25))
                p.addLine(to:CGPoint(x: 20, y: 0))
                p.addLine(to:CGPoint(x: 40, y: 25))
                p.fill()
            }
            UIGraphicsPopContext()
            
        }
    }
