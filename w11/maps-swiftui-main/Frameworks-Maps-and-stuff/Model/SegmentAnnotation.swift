//
//  SegmentAnnotation.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/23/23.
//

import Foundation
import MapKit
import SwiftUI

final class SegmentAnnotation: ObservableObject, Identifiable{
    var id: UUID
    @Published var selectedPickerSegment: PickerSegment
    @Published var mapAnnotation: MapAnnotationCustom
    
    static var dataDictionary: [PickerSegment : MapAnnotationCustom]{
        let dukeCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(AppConstants.dukeCoordinates.0), longitude: CLLocationDegrees(AppConstants.dukeCoordinates.1))
        var result: [PickerSegment : MapAnnotationCustom] = [:]
        
        let deAnnotation = MKPointAnnotation()
        deAnnotation.coordinate = dukeCoordinate2D
        deAnnotation.title = "Title"
        deAnnotation.subtitle = "Subtitle"
        let deMapAnnotation = MapAnnotationCustom(annotation: deAnnotation, view: AnyView(Image(systemName: "mappin.circle.fill").foregroundColor(.red).imageScale(.large)))
        
        let rtMapAnnotation = MapAnnotationCustom(annotation: deAnnotation, view: AnyView(Group{
            Triangle()
                .foregroundColor(.red.opacity(0.3))
            
        }))
        /*
         let lat = self.annloc.latitude
         let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
         var c = MKMapPoint(self.annloc)
         c.x += 150/metersPerPoint
         c.y -= 50/metersPerPoint
         var p1 = MKMapPoint(x: c.x, y: c.y)
         p1.y -= 100/metersPerPoint
         var p2 = MKMapPoint(x: c.x, y: c.y)
         p2.x += 100/metersPerPoint
         var p3 = MKMapPoint(x: c.x, y: c.y)
         p3.x += 300/metersPerPoint
         p3.y -= 400/metersPerPoint
         var pts = [
             p1, p2, p3
         ]
         tri = MKPolygon(points:&pts, count:3)
         self.map.addOverlay(tri)
         */
        
        
        
        result[.De] = deMapAnnotation
        result[.RT] = rtMapAnnotation
        
        return result
    }
    
    init(_ id: UUID? = nil, selectedPickerSegment: PickerSegment, mapAnnotation: MapAnnotationCustom){
        self.id = id ?? UUID()
        self.selectedPickerSegment = selectedPickerSegment
        self.mapAnnotation = mapAnnotation
    }
    
}

