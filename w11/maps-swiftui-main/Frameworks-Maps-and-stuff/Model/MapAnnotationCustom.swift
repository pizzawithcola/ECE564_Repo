//
//  MapAnnotation.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/22/23.
//

import Foundation
import MapKit
import SwiftUI

struct MapAnnotationCustom: Identifiable{
    var id: UUID
    var annotation: MKPointAnnotation
    var customView: AnyView?
    
    init(){
        self.id = UUID()
        self.annotation = MKPointAnnotation()
    }
    
    init(_ ann: MKPointAnnotation){
        self.id = UUID()
        self.annotation = ann
    }
    
    init(_ id: UUID, annotation ann: MKPointAnnotation){
        self.id = id
        self.annotation = ann
    }
    
    init(_ id: UUID? = nil, annotation ann: MKPointAnnotation, view customView: AnyView){
        self.id = id ?? UUID()
        self.annotation = ann
        self.customView = customView
    }
}
