//
//  MapAnnotation.swift
//  13_Frameworks
//
//  Created by Richard Telford on 4/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//


import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate : CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }
    
}
