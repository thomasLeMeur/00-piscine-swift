//
//  ViewController.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    static var API : ApiController!
    static var it: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.it = self
        ViewController.API = ApiController()
        ViewController.API.getAppToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectBtnAction(_ sender: Any) {
        
        ViewController.API.authenticateUser()
    }
    
    @IBAction func decoAction(_ sender: Any) {
        
        ViewController.API.disconnect()
        
    }

    @IBAction func voirTopicsAction(_ sender: Any) {
        
        if ViewController.API.user != nil {
            segueToTopics()
        }
    }
    
    func segueToTopics() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "topics", sender: "batman")
        }
    }
    
}

