//
//  MapOverlay.swift
//  13_Frameworks
//
//  Created by Richard Telford on 4/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//


import UIKit
import MapKit

class MapOverlay: NSObject, MKOverlay {
    var coordinate : CLLocationCoordinate2D {
        get {

            let pt = MKMapPoint(x: self.boundingMapRect.midX, y: self.boundingMapRect.midY)
            return pt.coordinate
        }
    }
    
    var boundingMapRect : MKMapRect
    var path : UIBezierPath!
    
    init(rect:MKMapRect) {
        self.boundingMapRect = rect
        super.init()
    }
    
}

class MapOverlayRenderer : MKOverlayRenderer {
    var angle : CGFloat = 0
    
    init(overlay:MKOverlay, angle:CGFloat) {
        self.angle = angle
        super.init(overlay:overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in con: CGContext) {
        con.setStrokeColor(UIColor.black.cgColor)
        con.setFillColor(UIColor.red.withAlphaComponent(0.2).cgColor)
        con.setLineWidth(1.2/zoomScale)
        
        let unit = CGFloat((overlay.boundingMapRect).width/4.0)
        
        let p = CGMutablePath()
        let start = CGPoint(0, unit*1.5)
        let p1 = CGPoint(start.x+2*unit, start.y)
        let p2 = CGPoint(p1.x, p1.y-unit)
        let p3 = CGPoint(p2.x+unit*2, p2.y+unit*1.5)
        let p4 = CGPoint(p2.x, p2.y+unit*3)
        let p5 = CGPoint(p4.x, p4.y-unit)
        let p6 = CGPoint(p5.x-2*unit, p5.y)
        let points = [
            start, p1, p2, p3, p4, p5, p6
        ]
        // rotate the arrow around its center
        let t1 = CGAffineTransform(translationX: unit*2, y: unit*2)
        let t2 = t1.rotated(by:self.angle)
        let t3 = t2.translatedBy(x: -unit*2, y: -unit*2)
        p.addLines(between: points, transform: t3)
        p.closeSubpath()
        
        con.addPath(p)
        con.drawPath(using: .fillStroke)
    }
}




