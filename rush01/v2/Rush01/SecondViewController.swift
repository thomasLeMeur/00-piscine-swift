//
//  SecondViewController.swift
//  Rush01
//
//  Created by Julian SCARPONE on 6/23/17.
//  Copyright © 2017 Julian SCARPONE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapkit: MKMapView!
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTuples = ViewController.locations
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if (ViewController.nbr == 2) {
            pinnedTwo()
            calculateSegmentDirections(index: 0, time: 0, routes: [])
        } else {
            pinnedOne()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pinnedOne() {
        let coord = locationTuples[0].mapItem?.placemark.coordinate
        let origin = MKPointAnnotation()
        origin.title = "C'est ici"
        origin.coordinate = coord!
        mapkit.addAnnotation(origin)
        
        
        let pinToZoomOn = origin
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
        mapkit.setRegion(region, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func pinnedTwo() {
        let coord = locationTuples[0].mapItem?.placemark.coordinate
        let origin = MKPointAnnotation()
        origin.title = "De là"
        origin.coordinate = coord!
        mapkit.addAnnotation(origin)
        
        let coord2 = locationTuples[1].mapItem?.placemark.coordinate
        let origin2 = MKPointAnnotation()
        origin2.title = "à là"
        origin2.coordinate = coord2!
        mapkit.addAnnotation(origin2)
    }
    
    func calculateSegmentDirections(index: Int, time: TimeInterval, routes: [MKRoute]) {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = locationTuples[0].mapItem
        request.destination = locationTuples[1].mapItem
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate (completionHandler: {
            (response: MKDirectionsResponse?, error: Error?) in
            if let routeResponse = response?.routes {
                let quickestRouteForSegment: MKRoute =
                    routeResponse.sorted(by: {$0.expectedTravelTime <
                        $1.expectedTravelTime})[0]
                
                self.plotPolyline(route: quickestRouteForSegment)
                
            } else if let _ = error {
                let alertController = UIAlertController(title: "Aucune route possible", message:
                    "Pas de trajet possible entre vos deux points", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func plotPolyline(route: MKRoute) {
        mapkit.add(route.polyline)
        mapkit.setVisibleMapRect(
            route.polyline.boundingMapRect,
            edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
            animated: false
        )
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
}

