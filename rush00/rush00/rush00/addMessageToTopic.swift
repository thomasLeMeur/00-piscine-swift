    //
//  addMessageToTopic.swift
//  rush00
//
//  Created by Julian SCARPONE on 6/18/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

class AddMessageVC: UIViewController {
    
    static var API : ApiController!
    static var it: AddMessageVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddMessageVC.it = self
        AddMessageVC.API = ViewController.API
        AddMessageVC.API.getAppToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func addMessageBtn(_ sender: Any) {
        
        if (!textView.text.isEmpty) {
            
            let msg = textView!.text
            AddMessageVC.API.createMessage(message: msg!)
            self.performSegue(withIdentifier: "backToThird", sender: "joker")
        }
    }
    
}
