//
//  ViewController.swift
//  rush01
//
//  Created by Thomas LE MEUR on 6/23/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var actLocBtn: UIButton!

    static var it: ViewController!
    
    @IBAction func usrUser(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func goAction(_ sender: UIButton) {
        if !isGoing {
            isGoing = true
            nbFailed = 0
            nbSucceeded = 0
            checkEnteredAddress(text: locationTuples[0].textField, index: 0)
            if destination.text != "" {
                checkEnteredAddress(text: locationTuples[1].textField, index: 1)
            }
        }
    }
    
    @IBAction func swapAction(_ sender: UIButton) {
        swap(&origin.text, &destination.text)
        swap(&locationTuples[0].mapItem, &locationTuples[1].mapItem)
    }
    
    var nbSucceeded: Int!
    var nbFailed: Int!
    var isGoing: Bool!
    var locationManager = CLLocationManager()
    var locationTuples: [(textField: UITextField, mapItem: MKMapItem?)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actLocBtn.backgroundColor = .clear
        actLocBtn.layer.cornerRadius = 5
        actLocBtn.layer.borderWidth = 1
        actLocBtn.layer.borderColor = UIColor.black.cgColor
        isGoing = false
        ViewController.it = self

        nbFailed = 0
        nbSucceeded = 0
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        locationTuples = [(origin, nil), (destination, nil)]
    }
    
    func checkEnteredAddress(text: UITextField, index: Int) {
        CLGeocoder().geocodeAddressString(text.text!, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.locationTuples[index].mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String: Any]?))
                text.text = self.formatAddressFromPlacemark(placemark)
                self.nbSucceeded! += 1
            } else {
                self.nbFailed! += 1
            }
            self.adressChecked()
        })
    }
    
    func adressChecked() {
        if nbSucceeded + nbFailed > 1 || destination.text == "" {
            isGoing = false
            if nbFailed > 0 {
                let alertController = UIAlertController(title: "Error", message:
                        "The adresses are wrong", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
            } else {
                performSegue(withIdentifier: "mapSegue", sender: "toto")
            }
        }
    }
    
    func formatAddressFromPlacemark(_ placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.locationTuples[0].mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String: Any]?))
                self.origin.text = self.formatAddressFromPlacemark(placemark)
                self.locationManager.stopUpdatingLocation()
            }
        })
    }
}

