//
//  ViewController.swift
//  Rush01
//
//  Created by Julian SCARPONE on 6/23/17.
//  Copyright © 2017 Julian SCARPONE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    static var addresses: [String] = []
    static var nbr: Int = 0
    static var locations: [(textField: UITextField?, mapItem: MKMapItem?)] = []
    
    let locationManager = CLLocationManager()
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var destinationField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // 3
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        locationTuples = [(sourceField, nil), (destinationField, nil)]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ViewController.nbr = 0
        ViewController.locations = []
    }

    @IBAction func getPos(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }

    @IBAction func RightClick(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "tableView", sender: "robin")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(
            locations.last!,
            completionHandler: {
                (placemarks:[CLPlacemark]?, error:Error?) -> Void in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    self.locationTuples[0].mapItem = MKMapItem(
                        placemark: MKPlacemark(
                            coordinate: placemark.location!.coordinate,
                            addressDictionary: placemark.addressDictionary as! [String:AnyObject]?
                        )
                    )
                    self.sourceField.text = self.formatAddressFromPlacemark(placemark: placemark)
                }
        }
        )
        locationManager.stopUpdatingLocation()
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joined(separator: ", ")
    }
    
    @IBAction func calcul(_ sender: Any) {
        view.endEditing(true)
        let srcTextField = locationTuples[0].textField
        let destTextField = locationTuples[1].textField
        
        ViewController.nbr = 0
        checkEnteredAddress(text: srcTextField!, index: 0)
        if (!(destTextField?.text?.isEmpty)!) {
            checkEnteredAddress(text: destTextField!, index: 1)
        }
    }
    
    func checkEnteredAddress(text: UITextField, index: Int) {
        CLGeocoder().geocodeAddressString(text.text!, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemarks = placemarks {
                ViewController.addresses = []
                for placemark in placemarks {
                    ViewController.addresses.append(self.formatAddressFromPlacemark(placemark: placemark))
                }
                let placemark = placemarks[0]
                self.locationTuples[index].mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String: Any]?))
                
                
                let str: String = text.text!
                let str2: String = self.formatAddressFromPlacemark(placemark: placemark)
                if (str.compare(str2).rawValue != 0) {
                    text.text = self.formatAddressFromPlacemark(placemark: placemark)
                    self.printAlert()
                } else {
                    ViewController.nbr += 1
                    print(ViewController.nbr)
                    if (ViewController.nbr == 1 && (self.locationTuples[1].textField?.text?.isEmpty)!) {
                        self.testSegue()
                    } else if (ViewController.nbr == 2 && !(self.locationTuples[1].textField?.text?.isEmpty)!) {
                        self.testSegue()
                    }
                }
            } else {
                self.printAlert()
            }
        })
    }
    
    func testSegue() {
        if (locationTuples[0].mapItem == nil && locationTuples[1].mapItem == nil) {
            printAlert()
        } else {
            ViewController.locations = locationTuples
            if (ViewController.nbr > 0) {
                print("CA DEVRAIT MARCHER BORDEL")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "map", sender: "robin")
                }
            }
        }
    }
    
    func printAlert() {
        let alertController = UIAlertController(title: "Remplissez les champs", message:
                "Le champs doit etre rempli!\nCorrectement", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func swapAction(_ sender: Any) {
        swap(&sourceField.text, &destinationField.text)
        swap(&locationTuples[0].mapItem, &locationTuples[1].mapItem)
    }
}
