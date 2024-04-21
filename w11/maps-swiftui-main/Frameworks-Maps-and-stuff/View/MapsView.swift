//
//  MapsView.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/12/23.
//

import SwiftUI
import MapKit

struct MapsView: View {
    @State var selectedSegment: PickerSegment
    @ObservedObject var mapSegmentAnnotation: SegmentAnnotation
    private var dataSetDict: [PickerSegment : MapAnnotationCustom]
    
    
    // Variables related to Map
    private var mapCenter: CLLocationCoordinate2D
    private var mapSpan: MKCoordinateSpan
    @State private var mapRegion: MKCoordinateRegion
    
    init(){
        selectedSegment = .De
        mapCenter = CLLocationCoordinate2D(latitude: AppConstants.dukeCoordinates.0, longitude: AppConstants.dukeCoordinates.1)
        mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapRegion = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        dataSetDict = SegmentAnnotation.dataDictionary
        mapSegmentAnnotation = SegmentAnnotation(selectedPickerSegment: self.dataSetDict.first!.key, mapAnnotation: self.dataSetDict.first!.value
        )
    }
    
    
    var body: some View {
        VStack {
            
            // MARK: Segmented Picker
            Spacer(minLength: 20)
            Picker("", selection: $mapSegmentAnnotation.selectedPickerSegment){
                ForEach(PickerSegment.allCases, id: \.self){
                    Text($0.rawValue)
                }
            }
            .onChange(of: mapSegmentAnnotation.selectedPickerSegment, perform: { segment in
                guard let currentMapAnnotation = dataSetDict[segment] else{
                    return
                }
                mapSegmentAnnotation.mapAnnotation = currentMapAnnotation
            })
            .pickerStyle(.segmented)
            .padding([.leading, .trailing], 40.0)
            
            //MARK: Map
            Spacer(minLength: 20)
            Map(coordinateRegion: $mapRegion, showsUserLocation: false, userTrackingMode: .none, annotationItems: [mapSegmentAnnotation.mapAnnotation]){ currentMapAnnotation in
                MapAnnotation(coordinate: currentMapAnnotation.annotation.coordinate, content: {
                    currentMapAnnotation.customView
                })
            }
                .padding([.leading, .trailing])
                .tint(.green)
            
            
            //MARK: Button
            Spacer(minLength: 40)
            Button(action: {
                let mapPlacemark = MKPlacemark(coordinate: self.mapCenter)
                let mapItem = MKMapItem(placemark: mapPlacemark)
                mapItem.name = "The home of Cameron Crazies"
                mapItem.openInMaps(launchOptions: [
                    MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: mapRegion.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: mapRegion.span)
                ])
            }, label: {
                Text("Show in Apple Maps")
                    .fontWeight(.bold)
            })
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            Spacer(minLength: 60)
        }
        
    }
}

struct MapsView_Previews: PreviewProvider {
    static var previews: some View {
        MapsView()
    }
}
/*
 Idea:
 
 Make a class like this;
 class MapSegment: ObservableObject{
 @Published var selectedMapSegment: PickerSegment
 var correspondingMapLocation: MKPointAnnotation
 }
 MKPointAnnotation only if its in swiftUI
 
 Then, in MapsView, we can create a State Variable of Type MapSegment
 selection: $variableName.selectedMapSegment
 */
