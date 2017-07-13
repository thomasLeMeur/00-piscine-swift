//
//  AddTopicViewController.swift
//  rush00
//
//  Created by Julian SCARPONE on 6/18/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

class AddTopicVC: UIViewController {

    static var API : ApiController!
    static var it: AddTopicVC!
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddTopicVC.it = self
        AddTopicVC.API = ViewController.API
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var content: UITextView!
    
    @IBAction func rightBtnAction(_ sender: Any) {
        
        if (!name.text!.isEmpty && !content.text!.isEmpty) {
            
            AddTopicVC.API.createTopic(topicName: name.text!, topicContent: content.text!)
            self.performSegue(withIdentifier: "backToSecondFromAddTopic", sender: "joker")
            
        }
    }
    
}
