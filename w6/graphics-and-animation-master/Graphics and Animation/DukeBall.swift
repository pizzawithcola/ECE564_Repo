//
//  DukeBall.swift
//  Graphics and Animation
//
//  Created by Richard Telford on 2/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

class DukeBall: UIView {

        override func draw(_ rect: CGRect) {
            
            let p = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))
            UIColor.blue.setFill()
            p.fill()
            
            let textLine = "Duke"
            let myFont = UIFont(name: "Zapfino", size: 20.0)

            let myShadow = NSShadow()
            myShadow.shadowBlurRadius = 3
            myShadow.shadowOffset = CGSize(width: 3, height: 3)
            myShadow.shadowColor = UIColor.gray

            let myAttributes = [
                NSAttributedString.Key.shadow: myShadow,
                NSAttributedString.Key.font: myFont,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            let attString = NSAttributedString(string: textLine, attributes: (myAttributes) as [NSAttributedString.Key : Any])
            attString.draw(
            at: CGPoint(x: 15,y: 25))

        }
    }
