//
//  MapsViewController.swift
//  13_Frameworks
//
//  Created by Richard Telford on 4/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {
    
    var which = style.Default
    var annloc = CLLocationCoordinate2DMake(DUKELAT,DUKELONG)
    var ann1 = MKPointAnnotation()
    var ann2 = MapAnnotation(location: CLLocationCoordinate2DMake(DUKELAT, DUKELONG))
    var ann3 = MKPointAnnotation()
    var tri = MKPolygon()
    var over = MapOverlay(rect: MKMapRect(x: 10, y: 10, width: 10, height: 10))

    
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        mapButton.bounds = CGRect(x: 0, y: 0, width: 200, height:50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        self.map.tintColor = .green
        let loc = CLLocationCoordinate2DMake(DUKELAT,DUKELONG)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let reg = MKCoordinateRegion(center: loc, span: span)
        self.map.region = reg
        
        seg.removeSegment(at: 1, animated: false)
        seg.removeSegment(at: 0, animated: false)
        seg.insertSegment(withTitle: "De", at: 0, animated: true)
        seg.insertSegment(withTitle: "Gr", at: 1, animated: true)
        seg.insertSegment(withTitle: "B1", at: 2, animated: true)
        seg.insertSegment(withTitle: "B2", at: 3, animated: true)
        seg.insertSegment(withTitle: "BM", at: 4, animated: true)
        seg.insertSegment(withTitle: "RT", at: 5, animated: true)
        seg.insertSegment(withTitle: "RA", at: 6, animated: true)
        seg.insertSegment(withTitle: "AP", at: 7, animated: true)
        
        seg.selectedSegmentIndex = 0
        
        mapButton.backgroundColor = UIColor.blue
        mapButton.layer.cornerRadius = 10
        mapButton.layer.borderWidth = 2
        mapButton.layer.borderColor = UIColor.black.cgColor
        mapButton.layer.frame = mapButton.frame.insetBy(dx: -5,dy: -5)
        mapButton.isHidden = false
        mapButton.titleLabel?.numberOfLines = 0
        mapButton.titleLabel?.textAlignment = .center
        mapButton.titleLabel?.lineBreakMode = .byWordWrapping
        mapButton.titleLabel?.font = UIFont(name: "Arial Bold", size: CGFloat(18))
        mapButton.setTitleColor(UIColor.white, for: UIControl.State())
        mapButton.setTitleColor(UIColor.white, for: .highlighted)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if which == .Default {
            self.ann1 = MKPointAnnotation()
            self.ann1.coordinate = self.annloc
            self.map.addAnnotation(self.ann1)
            return
        }
        // MARK: Pins, Basic Bball
        switch which {
        case .GreenPin:
            fallthrough
        case .BBall:
            fallthrough
        case .BBall2:
            self.ann1 = MKPointAnnotation()
            self.ann1.coordinate = self.annloc
            self.ann1.title = "Crazies here"
            self.ann1.subtitle = "Go Devils!"
            self.map.addAnnotation(self.ann1)
        default:
            self.ann2 = MapAnnotation(location:self.annloc)
            self.ann2.title = "Crazies here"
            self.ann2.subtitle = "Go Blue Devils!"
            self.map.addAnnotation(self.ann2)
            delay(2) {
                UIView.animate(withDuration: 1) {
                    var loc = self.ann2.coordinate
                    loc.latitude = loc.latitude - 0.001
                    loc.longitude = loc.longitude - 0.002
                    self.ann2.coordinate = loc
                }
            }
        }
        // MARK: Red Triangle
        if which == .RedTriangle {
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
        }
        // MARK: Red Arrow
        if which == .RedArrow {
            // start with our position and derive a unit for drawing
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            let c = MKMapPoint(self.annloc)
            let unit = CGFloat(75.0/metersPerPoint)
            // size and position the overlay
            let sz = CGSize(4*unit, 4*unit)
            let mr = MKMapRect(x: c.x + 2*Double(unit), y: c.y - 4.5*Double(unit), width: Double(sz.width), height: Double(sz.height))
            // describe the arrow as a CGPath
            let p = CGMutablePath()
            let start = CGPoint(0, unit*1.5)
            let p1 = CGPoint(start.x+2*unit, start.y)
            let p2 = CGPoint(p1.x, p1.y-unit)
            let p3 = CGPoint(p2.x+unit*2, p2.y+unit*1.5)
            let p4 = CGPoint(p2.x, p2.y+unit*3)
            let p5 = CGPoint(p4.x, p4.y-unit)
            let p6 = CGPoint(p5.x-2*unit, p5.y)
            let points = [
                start, p1, p2, p3, p4, p5, p6
            ]
            let t1 = CGAffineTransform(translationX: unit*2, y: unit*2)
            let t2 = t1.rotated(by: 0.8 * .pi)
            let t3 = t2.translatedBy(x: -unit*2, y: -unit*2)
            p.addLines(between: points, transform: t3)
            p.closeSubpath()
            over = MapOverlay(rect:mr)
            over.path = UIBezierPath(cgPath:p)
            self.map.addOverlay(over)
        }
        // MARK:  Red Arrow And Pin
        if which == .RedArrowAndPin {
            
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            let c = MKMapPoint(self.annloc)
            let unit = 75.0/metersPerPoint
            // size and position the overlay bounds on the earth
            let sz = CGSize(4*CGFloat(unit), 4*CGFloat(unit))
            let mr = MKMapRect(x: c.x + 2*unit, y: c.y - 4.5*unit, width: Double(sz.width), height: Double(sz.height))
            over = MapOverlay(rect:mr)
            self.map.addOverlay(over, level:.aboveRoads)
            
            ann3.coordinate = over.coordinate
            ann3.title = "Great ball games this way!"
            self.map.addAnnotation(ann3)
        }
    }
    // MARK: Button Handler
    @IBAction func showPOIinMapsApp (_ sender: Any) {
        let p = MKPlacemark(coordinate:self.annloc, addressDictionary:nil)
        let mi = MKMapItem(placemark: p)
        mi.name = "The home of Cameron Crazies"
        mi.openInMaps(launchOptions:[
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate:self.map.region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:self.map.region.span)
        ])
    }
    
    // MARK: Alert box when info button pressed
    @objc func mapAnnotationAlert() {
        let alert = UIAlertController(title: "Game Information", message: "Gates open at 6pm", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        return
    }
    // MARK: Action when Segment changes
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        let rv = String(sender.selectedSegmentIndex + 1)
        which = style(rawValue: rv)!
        self.map.removeAnnotation(ann1)
        self.map.removeAnnotation(ann2)
        self.map.removeOverlay(tri)
        self.map.removeOverlay(over)
        self.map.removeAnnotation(ann3)
        self.view.setNeedsLayout()
    }
} 


