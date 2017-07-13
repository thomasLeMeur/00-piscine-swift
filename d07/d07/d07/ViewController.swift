//
//  ViewController.swift
//  d07
//
//  Created by Thomas LE MEUR on 6/21/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {

    static let RECAST_TOKEN = "edebec7b85ac3d7c0fece389ff6681a0"
    static let DARKSKY_TOKEN = "47086b9eaf42a3f16323c82fb895e68e"
    
    var bot : RecastAIClient?
    let client = DarkSkyClient(apiKey: ViewController.DARKSKY_TOKEN)
    
    @IBOutlet weak var requestText: UITextField!
    @IBOutlet weak var responseLabel: UILabel!

    @IBAction func searchButton(_ sender: UIButton) {
        responseLabel.text = ""
        if (!(requestText.text?.isEmpty)!) {
            bot?.textRequest(requestText.text!, successHandler: recastSucceeded, failureHandle: recastFailed)
        }
        requestText.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        responseLabel.text = ""

        bot = RecastAIClient(token : ViewController.RECAST_TOKEN)
        bot = RecastAIClient(token : ViewController.RECAST_TOKEN, language: "fr")
        
        client.units = .si
        client.language = .french
        
    }
    
    func forecastRequest(_ location: [String : AnyObject]) {
        client.getForecast(latitude: location["lat"] as! Double, longitude: location["lng"] as! Double) { result in
            switch result {
            case .success(let currentForecast, _):
                if let daily = currentForecast.daily {
                    if let meteo = daily.summary {
                        self.responseLabel.text = meteo
                    } else {
                        self.responseLabel.text = "Error 5"
                    }
                } else {
                    self.responseLabel.text = "Error 6"
                }
            case .failure(_):
                self.responseLabel.text = "Error 7"
            }
        }
    }
    
    func recastSucceeded(rep: Response) {
        let intent = rep.intent()
        if intent == nil {
            responseLabel.text = "Error 2"
        } else {
            if intent!.slug != "weather" {
                responseLabel.text = "Weather intent expected, found '\(intent!.slug!)'"
            } else {
                let location = rep.get(entity: "location")
                if location == nil {
                    responseLabel.text = "Error 3"
                } else {
                    if location?["lat"] == nil || location?["lng"] == nil {
                        responseLabel.text = "Error 4"
                    } else {
                        forecastRequest(location!)
                    }
                }
            }
        }
    }
    
    func recastFailed(err: Error) {
        responseLabel.text = "Error 1"
    }
}

