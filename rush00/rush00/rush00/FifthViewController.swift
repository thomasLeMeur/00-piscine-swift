//
//  FifthViewController.swift
//  rush00
//
//  Created by Julian SCARPONE on 6/18/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

class FifthViewController: UIViewController {
    
    static var API: ApiController!
    static var it: FifthViewController!
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UITextView!
    
    static var reponse: Response!

    override func viewDidLoad() {
        super.viewDidLoad()
        FifthViewController.reponse = FourthViewController.responseSelected
        login.text = FifthViewController.reponse.authorLogin
        date.text = FifthViewController.reponse.date
        content.text = FifthViewController.reponse.content
        FifthViewController.it = self
        FifthViewController.API = ViewController.API
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
