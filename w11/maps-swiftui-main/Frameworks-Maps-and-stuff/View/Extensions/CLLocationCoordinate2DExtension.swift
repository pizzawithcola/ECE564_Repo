//
//  CLLocationCoordinate2DExtension.swift
//  Frameworks-Maps-and-stuff
//
//  Created by loaner on 3/23/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
