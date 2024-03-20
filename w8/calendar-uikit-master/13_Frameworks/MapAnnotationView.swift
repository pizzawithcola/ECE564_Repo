//
//  BballAnnotationView.swift
//  13_Frameworks
//
//  Created by Richard Telford on 4/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
import MapKit

class BballAnnotationView: MKAnnotationView {

  override init(annotation:MKAnnotation?, reuseIdentifier:String?) {
           super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
           let im = UIImage(named:"basketball.png")!
           self.frame = CGRect(0, 0, im.size.width / 3.0 + 5, im.size.height / 3.0 + 5)
           self.centerOffset = CGPoint(0,-20)
           self.isOpaque = false
    
       }
       
       required init(coder: NSCoder) {
           fatalError("NSCoding not supported")
       }
       
       override func draw(_ rect: CGRect) {
           let im = UIImage(named:"basketball.png")!
           im.draw(in:self.bounds.insetBy(dx: 5, dy: 5))
       }

}
