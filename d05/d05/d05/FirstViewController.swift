//
//  FirstViewController.swift
//  d05
//
//  Created by Thomas LE MEUR on 6/19/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    static var map: FirstViewController!
    var locationManager = CLLocationManager()
    var isCentered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCentered = false
        FirstViewController.map = self
        mapView.showsUserLocation = true
        mapView.addAnnotations(Location.allPins)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }

    override func viewWillAppear(_ animated: Bool) {
        isCentered = false
        centerMapOnLocation(location: SecondViewController.selectedLocation)
    }
    
    func centerMapOnLocation(location: Location) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(location.latitude, location.longitude), location.zoom, location.zoom)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func segmentsAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
            isCentered = false
        case 1:
            mapView.mapType = MKMapType.satellite
            isCentered = false
        case 2:
            mapView.mapType = MKMapType.hybrid
            isCentered = false
        default:
            print("Unknown Segment Controller Index (\(sender.selectedSegmentIndex))")
        }
    }

    @IBAction func targetMeAction(_ sender: UIButton) {
        isCentered = true
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isCentered {
            print(locations[0])
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(locations[0].coordinate, 1000, 1000)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            for i in 0..<Location.allLocations.count {
                if Location.allLocations[i].latitude == annotation.coordinate.latitude &&
                   Location.allLocations[i].longitude == annotation.coordinate.longitude {
                    annotationView.pinTintColor = Location.allLocations[i].color
                    annotationView.canShowCallout = true
                }
            }
            return annotationView
        }
    }
}

