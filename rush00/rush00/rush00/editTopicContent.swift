//
//  editTopicContent.swift
//  rush00
//
//  Created by Julian SCARPONE on 6/18/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

class EditTopicContentVC: UIViewController {
    
    
    static var API : ApiController!
    static var it: EditTopicContentVC!
    
    override func viewDidLoad() {
        textView.text = SecondViewController.selectedTopic.name
        super.viewDidLoad()
        EditTopicContentVC.it = self
        EditTopicContentVC.API = ViewController.API
        EditTopicContentVC.API.getAppToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func rightBtnAction(_ sender: Any) {
        
        if (!textView.text.isEmpty) {

            EditTopicContentVC.API.updateTopic(topicName: textView.text)
            EditTopicContentVC.API.loadAllMessages(fromTopicId: SecondViewController.selectedTopic.id)
            self.performSegue(withIdentifier: "backToSecondView", sender: "joker")
        }
    }
}
