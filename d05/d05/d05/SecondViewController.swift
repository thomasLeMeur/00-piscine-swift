//
//  SecondViewController.swift
//  d05
//
//  Created by Thomas LE MEUR on 6/19/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    static var selectedLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Location.allLocations.append(Location(name: "42", latitude: 48.896684, longitude: 2.318376, infos: "Ecole trop stylee", zoom: 1000, color: UIColor.red))
        Location.allLocations.append(Location(name: "New York", latitude: 40.712784, longitude: -74.005941, infos: "High", zoom: 10000, color: UIColor.cyan))
        Location.allLocations.append(Location(name: "Grenoble", latitude: 45.188529, longitude: 5.724524, infos: "Snow town", zoom: 10000, color: UIColor.blue))
        Location.allLocations.append(Location(name: "Reims", latitude: 49.258329, longitude: 4.031696, infos: "Big church", zoom: 10000, color: UIColor.green))
        Location.allLocations.append(Location(name: "Moldavie", latitude: 47.411631, longitude: 28.369885, infos: "Sax country", zoom: 500000, color: UIColor.purple))
        Location.allLocations.append(Location(name: "Circuit", latitude: 45.526274, longitude: -122.647971, infos: "Far away", zoom: 10000, color: UIColor.white))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Location.allLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")
        cell?.textLabel?.text = Location.allLocations[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SecondViewController.selectedLocation = Location.allLocations[indexPath.row]
        self.tabBarController?.selectedIndex = 1
    }
}

