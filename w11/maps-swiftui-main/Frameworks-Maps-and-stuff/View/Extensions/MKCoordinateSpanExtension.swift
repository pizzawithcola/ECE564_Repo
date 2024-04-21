//
//  MKCoordinateSpanExtension.swift
//  Frameworks-Maps-and-stuff
//
//  Created by loaner on 3/23/23.
//

import Foundation
import MapKit

extension MKCoordinateSpan: Equatable{
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}
