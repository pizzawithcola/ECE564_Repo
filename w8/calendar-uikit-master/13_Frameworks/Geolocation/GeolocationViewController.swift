//
//  GeolocationViewController.swift
//  13_Frameworks
//
//  Created by Richard Telford on 4/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
import MapKit

class GeolocationViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    @IBOutlet var map : MKMapView!
    @IBOutlet weak var directions: UITextView!
    let locman = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
    }
    
    @IBAction func ShowInMaps (_ sender: Any!) {
        let mi = MKMapItem.forCurrentLocation()
        _ = MKCoordinateSpan.init(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        mi.openInMaps(launchOptions:[
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
            // MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:span)
        ])
    }
    
    @IBAction func ShowInApp (_ sender: Any!) {
        self.locman.requestWhenInUseAuthorization()
        self.map.userTrackingMode = .follow
    }

    @IBAction func reportAddress (_ sender: Any!) {
        guard let loc = self.map.userLocation.location else {
            print("I don't know where you are now")
            return
        }
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(loc) { placemarks, error in
            guard let ps = placemarks, ps.count > 0 else {return}
            let p = ps[0]
            self.directions.text = p.postalAddress?.street
            self.directions.text += "\n"
            self.directions.text += p.postalAddress?.city ?? " "
            self.directions.text += ", "
            self.directions.text += p.postalAddress?.state ?? " "
            self.directions.text += "   "
            self.directions.text += p.postalAddress?.postalCode ?? "  "
        }
    }
    
    @IBAction func thaiFoodNearMapLocation (_ sender: Any!) {
        guard let loc = self.map.userLocation.location else {
            print("I don't know where you are now")
            return
        }
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = "Thai restaurant"
        req.region = MKCoordinateRegion.init(center: loc.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 1,longitudeDelta: 1))
        let search = MKLocalSearch(request:req)
        search.start { response, error in
            guard let response = response else {
                print(error as Any)
                return
            }
            //something changed in MapKit.  Had to comment out the line below to get Directions function to work.
  //          self.map.showsUserLocation = false
            let mi = response.mapItems[0]
            let place = mi.placemark
            let loc = place.location!.coordinate
            let reg = MKCoordinateRegion.init(center: loc, latitudinalMeters: 1200, longitudinalMeters: 1200)
            self.map.setRegion(reg, animated:true)
            let ann = MKPointAnnotation()
            ann.title = mi.name
            ann.subtitle = mi.phoneNumber
            ann.coordinate = loc
            self.map.addAnnotation(ann)
        }
    }
    
    @IBAction func directionsToThaiFood (_ sender: Any!) {
        let loc = self.map.userLocation.location
        if loc == nil {
            print("I don't know where you are now")
            return
        }
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = "Thai restaurant"
        req.region = self.map.region
        let search = MKLocalSearch(request:req)
        search.start { response, error in
            guard let response = response else {
                print(error as Any)
                return
            }
            print("Got restaurant address")
            let mi = response.mapItems[0]
            let req = MKDirections.Request()
            req.source = MKMapItem.forCurrentLocation()
            req.destination = mi
            req.transportType = .automobile
            let dir = MKDirections(request:req)
            dir.calculate { response, error in
                guard let response = response else {
                    print(error as Any)
                    return
                }
                print("got directions")
                let route = response.routes[0]
                let poly = route.polyline
                self.map.addOverlay(poly)
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
                    self.directions.text = outputText
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolyline {
            let v = MKPolylineRenderer(polyline:overlay)
            v.strokeColor = UIColor.blue.withAlphaComponent(0.8)
            v.lineWidth = 2
            return v
        }
        return MKOverlayRenderer()
    }
    
}
