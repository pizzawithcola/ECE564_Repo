//
//  Data.swift
//  13_Frameworks
//
//  Created by Richard Telford on 3/23/21.
//  Copyright © 2021 Duke Pratt. All rights reserved.
//

import UIKit

let DUKELAT = 35.9978
let DUKELONG = -78.9420

enum style : String {
    case Default = "1"  // default behavior for annotation
    case GreenPin = "2"  // annotation properties - dropping green pin
    case BBall = "3"  //  annotationView,  uses MKAnnotationView
    case BBall2 = "4" // custom annotationView, "BballAnnotationView"
    case BBallMove = "5"  // annotationView with animation
    case RedTriangle = "6"  // simple overlay, MKPolygon
    case RedArrow = "7"  // custom overlay, "MapOverlay"
    case RedArrowAndPin = "8"  // custom overlay and annotation
}
