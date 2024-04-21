//
//  MapViewDelegate.swift
//  13_Frameworks
//
//  Created by Richard Telford on 3/23/21.
//  Copyright © 2021 Duke Pratt. All rights reserved.
//
import UIKit
import MapKit

extension MapsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewFor")
        if which == .GreenPin {
            var v : MKAnnotationView! = nil
            if let t = annotation.title, t == "Crazies here" {
                let ident = "greenPin"
                v = mapView.dequeueReusableAnnotationView(withIdentifier:ident)
                if v == nil {
                    v = MKPinAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    (v as! MKPinAnnotationView).pinTintColor = MKPinAnnotationView.greenPinColor() // or any UIColor
                    v.canShowCallout = true
                    (v as! MKPinAnnotationView).animatesDrop = true
                    
                }
                v.annotation = annotation
            }
            return v
        }
        if which == .BBall {
            var v : MKAnnotationView! = nil
            if let t = annotation.title, t == "Crazies here" {
                let ident = "bball"
                v = mapView.dequeueReusableAnnotationView(withIdentifier:ident)
                if v == nil {
                    v = MKAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    v.image = UIImage(named:"basketball.png")
                    v.bounds.size.height /= 3.0
                    v.bounds.size.width /= 3.0
                    v.centerOffset = CGPoint(0,-20)
                    v.canShowCallout = true
                }
                v.annotation = annotation
            }
            return v
        }
        if which == .BBall2 {
            var v : MKAnnotationView! = nil
            if let t = annotation.title, t == "Crazies here" {
                let ident = "bball2"
                v = mapView.dequeueReusableAnnotationView(withIdentifier:ident)
                if v == nil {
                    v = BballAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    v.canShowCallout = true
                }
                v.annotation = annotation
            }
            return v
        }
        
        switch which {
        case .BBallMove:
            fallthrough
        case .RedTriangle:
            fallthrough
        case .RedArrow:
            fallthrough
        case .RedArrowAndPin:
            var v : MKAnnotationView! = nil
            if annotation is MapAnnotation {
                let ident = "bball"
                v = mapView.dequeueReusableAnnotationView(withIdentifier:ident)
                if v == nil {
                    v = BballAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    v.canShowCallout = true
                    let im = UIImage(named:"smileyWithTransparencyTiny.png")!
                        .withRenderingMode(.alwaysTemplate)
                    let iv = UIImageView(image:im)
                    v.leftCalloutAccessoryView = iv
                    let infoButton = UIButton(type:.infoLight)
                    infoButton.addTarget(self, action: #selector(mapAnnotationAlert), for: .allTouchEvents)
                    v.rightCalloutAccessoryView = infoButton
                    let lab = UILabel()
                    lab.text = "Let's go Blue Devils!"
                    lab.numberOfLines = 0
                    lab.font = lab.font.withSize(10)
                    v.detailCalloutAccessoryView = lab
                }
                v.annotation = annotation
                v.isDraggable = true
            }
            return v
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        print("didAdd")
        switch which {
        case .BBallMove:
            fallthrough
        case .RedTriangle:
            fallthrough
        case .RedArrow:
            fallthrough
        case .RedArrowAndPin:
            for aView in views {
                if aView.reuseIdentifier == "ball" {
                    aView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    aView.alpha = 0
                    UIView.animate(withDuration:0.8) {
                        aView.alpha = 1
                        aView.transform = .identity
                    }
                }
            }
        default:
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("renderFor")
        if which == .RedTriangle {
            if let overlay = overlay as? MKPolygon {
                let v = MKPolygonRenderer(polygon:overlay)
                v.fillColor = UIColor.red.withAlphaComponent(0.1)
                v.strokeColor = UIColor.red.withAlphaComponent(0.8)
                v.lineWidth = 2
                return v
            }
        }
        if which == .RedArrow {
            if let overlay = overlay as? MapOverlay {
                let v = MKOverlayPathRenderer(overlay:overlay)
                v.path = overlay.path.cgPath
                v.fillColor = UIColor.red.withAlphaComponent(0.2)
                v.strokeColor = .black
                v.lineWidth = 2
                return v
            }
        }
        if which == .RedArrowAndPin {
            if overlay is MapOverlay {
                let v = MapOverlayRenderer(overlay:overlay, angle: 0.8 * .pi)
                return v
            }
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        print("didChange")
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
}  // end of extension
