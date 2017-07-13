//
//  EditMessageVC.swift
//  rush00
//
//  Created by Julian SCARPONE on 6/18/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

class EditMessageVC: UIViewController {
    
    static var API : ApiController!
    static var it: EditMessageVC!
    
    override func viewDidLoad() {
        textView.text = ThirdViewController.selectedMsg.content
        super.viewDidLoad()
        EditMessageVC.it = self
        EditMessageVC.API = ViewController.API
        EditMessageVC.API.getAppToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var textView: UITextView!
    @IBAction func rightBtnAction(_ sender: Any) {
        if (!textView.text.isEmpty) {
            EditMessageVC.API.updateMessage(message: textView.text)
            self.performSegue(withIdentifier: "backToThirdFromEdit", sender: "joker")
        }
    }
}
