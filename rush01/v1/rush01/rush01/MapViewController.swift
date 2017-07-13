//
//  MapViewController.swift
//  rush01
//
//  Created by Thomas LE MEUR on 6/23/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var annotations: [MKPointAnnotation] = []
        
        let origin = MKPointAnnotation()
        origin.title = ViewController.it.origin.text
        origin.coordinate = ViewController.it.locationTuples[0].mapItem!.placemark.coordinate
        annotations.append(origin)
        
        if ViewController.it.destination.text == "" {
            origin.title = "C'est ici"
            centerPositionOnOrigin()
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let dest = MKPointAnnotation()
            dest.title = ViewController.it.destination.text
            dest.coordinate = ViewController.it.locationTuples[1].mapItem!.placemark.coordinate
            annotations.append(dest)
            calculateSegmentDirections()
        }
        mapView.addAnnotations(annotations)
    }
    
    func centerPositionOnOrigin() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(ViewController.it.locationTuples[0].mapItem!.placemark.coordinate, 25000, 25000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func plotPolyline(route: MKRoute) {
        mapView.add(route.polyline)
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
    }
    
    func calculateSegmentDirections() {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = ViewController.it.locationTuples[0].mapItem
        request.destination = ViewController.it.locationTuples[1].mapItem
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate (completionHandler: {
            (response: MKDirectionsResponse?, error: Error?) in
            if let routeResponse = response?.routes {
                let quickestRouteForSegment: MKRoute = routeResponse.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})[0]
                self.plotPolyline(route: quickestRouteForSegment)
                
            } else {
                let alertController = UIAlertController(title: "Error", message:
                    "The itineraire is impossible", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.centerPositionOnOrigin()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor.green.withAlphaComponent(0.75)
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
}
