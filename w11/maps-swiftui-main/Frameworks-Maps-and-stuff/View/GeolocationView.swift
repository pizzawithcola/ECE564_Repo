//
//  GeolocationView.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/12/23.
//

import SwiftUI
import MapKit

struct GeolocationView: View {
    @State private var mapRegion: MKCoordinateRegion
    @State private var directions: String
    @State private var locationManager: CLLocationManager
    @State private var currentMapUserTrackingMode: MapUserTrackingMode
    @State private var mapShowUserLocation: Bool
    @State private var annotations: [MapAnnotationCustom] = []
    
    
    init(){
        _mapRegion = State(initialValue: MKCoordinateRegion(MKMapRect()))
        _directions = State(initialValue: "")
        _locationManager = State(initialValue: CLLocationManager())
        _currentMapUserTrackingMode = State(initialValue: MapUserTrackingMode.none)
        _mapShowUserLocation = State(initialValue: false)
    }
    
    private func closestThaiFood(){
        guard let location = locationManager.location else{
            directions = "Reinstall app and give location permission for proper functioning"
            return
        }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Thai restaurant"
        searchRequest.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(1), longitudeDelta: CLLocationDegrees(1)))
        let search = MKLocalSearch(request: searchRequest)
        search.start{response, error in
            guard let response = response else{
                print(error as Any)
                return
            }
            let mapItem = response.mapItems[0]
            let place = mapItem.placemark
            let location = place.location!.coordinate
            mapRegion.center = location
            mapRegion.span = MKCoordinateRegion(center: location, latitudinalMeters: CLLocationDegrees(1200), longitudinalMeters: 1200).span
            
            let annotationItem = MKPointAnnotation()
            annotationItem.title = mapItem.name
            annotationItem.subtitle = mapItem.phoneNumber
            annotationItem.coordinate = location
            let newMapAnnotation = MapAnnotationCustom(annotationItem)
            annotations.append(newMapAnnotation)
        }
    }
    
    // Cannot use if-else for the condition when the user presses "Don't Allow"
    // Since according to https://developer.apple.com/documentation/corelocation/cllocationmanager/1620562-requestwheninuseauthorization
    // If Don't Allow is pressed once, then no further location requests are allowed.
    // Work-around(s): Reinstall app, manually enable location sharing in settings
    
    private func whereAmI(){
        locationManager.requestWhenInUseAuthorization()
        currentMapUserTrackingMode = .follow
        mapShowUserLocation = true
        guard let location = locationManager.location else{
            return
        }
        mapRegion.center = location.coordinate
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
    }
    
    private func showAddress(){
        guard let location = locationManager.location else{
            directions = "Reinstall app and give location permission for proper functioning"
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {placemarks, error in
            guard let placemarks = placemarks else {
                return
            }
            let placemark = placemarks[0]
            var address = ""
            address = placemark.subThoroughfare ?? ""
            address += address == "" ? "" : " "
            address += placemark.thoroughfare ?? ""
            address += "\n"
            address += placemark.locality ?? " "
            address += ", "
            address += placemark.administrativeArea ?? " "
            address += " "
            address += placemark.postalCode ?? "  "

            directions = address
            
        })
    }
    
    private func directionsToThaiFood(){
        guard let location = locationManager.location else{
            directions = "Reinstall app and give location permission for proper functioning"
            return
        }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Thai restaurant"
        searchRequest.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(1), longitudeDelta: CLLocationDegrees(1)))
        let search = MKLocalSearch(request: searchRequest)
        search.start{response, error in
            guard let response = response else{
                print(error as Any)
                return
            }
            let mapItem = response.mapItems[0]
            let request = MKDirections.Request()
            request.source = MKMapItem.forCurrentLocation()
            request.destination = mapItem
            request.transportType = .automobile
            
            let restaurantDirections = MKDirections(request: request)
            restaurantDirections.calculate{ response, error in
                guard let response = response else{
                    print(error as Any)
                    return
                }
                print("Got Directions")
                
                let route = response.routes[0]
                
                var outputText = ""
                var stepCount = 1
                for step in route.steps {
                    if (Int(step.distance) == 0) { continue }
                    let miles = step.distance / 1600
                    let milesString = String(format: "%.2f", miles)
                    outputText += "\(stepCount). Go \(milesString) miles, \(step.instructions)\n"
                    stepCount += 1
                }
                DispatchQueue.main.async {
                    directions = outputText
                }
            }
        }
    }
    
    var body: some View {
        VStack {
//            Spacer()
            //MARK: Direction Buttons
            HStack {
                VStack(alignment: .leading){
                    Button("Where am I?", action: whereAmI)
                    Button("Closest Thai Food", action: closestThaiFood)
                }
                VStack(alignment: .leading){
                    Button("Show Address", action: showAddress)
                    Button("Directions to Thai Food", action: directionsToThaiFood)
                }
            }
            //MARK: Map
            Map(coordinateRegion: $mapRegion, showsUserLocation: mapShowUserLocation, userTrackingMode: $currentMapUserTrackingMode, annotationItems: annotations){ currentAnnotation in
                MapAnnotation(coordinate: currentAnnotation.annotation.coordinate, content: {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                    Text(currentAnnotation.annotation.title ?? "")
                        .font(.caption2)
                })
            }
                .padding([.leading, .trailing])
                .tint(.green)
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 4, alignment: .center)
                .animation(.default, value: mapRegion)
            
            
            //MARK: 'Show in Apple Maps' Button
            Button(action: {
                let mapItem = MKMapItem.forCurrentLocation()
                _ = MKCoordinateSpan.init(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                mapItem.openInMaps(launchOptions: [
                    MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue
                ])
            }, label: {
                Text("Show in Apple Maps")
                    .fontWeight(.bold)
            })
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            //MARK: Directions Text Box
            GeometryReader{ geometry in
                ScrollView{
                    Text(directions)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .bottom, .leading, .trailing])
                        .frame(minHeight: geometry.size.height)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 3.1)
            .background(Color(uiColor: UIColor.systemGray5))
            Spacer()
            
        }
    }
}

struct GeolocationView_Previews: PreviewProvider {
    static var previews: some View {
        GeolocationView()
    }
}
