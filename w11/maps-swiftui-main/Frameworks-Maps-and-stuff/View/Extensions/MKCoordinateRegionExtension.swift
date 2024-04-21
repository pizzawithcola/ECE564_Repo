//
//  MKCoordinateRegionExtensions.swift
//  Frameworks-Maps-and-stuff
//
//  Created by loaner on 3/23/23.
//

import Foundation
import MapKit

extension MKCoordinateRegion: Equatable{
    
    // Conform to Equatable to enable animations
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span == rhs.span
    }
}
