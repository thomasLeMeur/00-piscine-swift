//
//  Location.swift
//  d05
//
//  Created by Thomas LE MEUR on 6/19/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject {
    var name: String
    var latitude: Double
    var longitude: Double
    var infos: String
    var zoom: Double
    var color: UIColor
    
    init (name: String, latitude: Double, longitude: Double, infos: String, zoom: Double, color: UIColor) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.infos = infos
        self.zoom = zoom
        self.color = color
        super.init()

        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        dropPin.title = name
        dropPin.subtitle = infos
        Location.allPins.append(dropPin)
    }

    static var allLocations : [Location] = []
    
    static var allPins : [MKPointAnnotation] = []
}
