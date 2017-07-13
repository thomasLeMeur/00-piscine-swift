//
//  ViewController.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    static var API : ApiController!
    static var it: ThirdViewController!
    static var selectedMsg: Message!
    
    @IBOutlet weak var myTableView: UITableView!

    @IBAction func navRightButton(_ sender: Any) {

        let alert = UIAlertController(title: "Actions", message: "Que Voulez-vous Faire?", preferredStyle: UIAlertControllerStyle.alert)
        
        if (ThirdViewController.API.user!.login == SecondViewController.selectedTopic.authorLogin) {
            alert.addAction(UIAlertAction(
                title: "Editer le topic",
                style: UIAlertActionStyle.default,
                handler: editTopic
            ))
            
            alert.addAction(UIAlertAction(
                title: "Supprimer le topic",
                style: UIAlertActionStyle.default,
                handler: deleteTopic
            ))
        }
        
        alert.addAction(UIAlertAction(
            title: "Ajouter un message",
            style: UIAlertActionStyle.default,
            handler: addMessage
        ))
        
       alert.addAction(UIAlertAction(
            title: "Rien finalement..",
            style: UIAlertActionStyle.default,
            handler: nil
       ))
        
        ThirdViewController.it.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThirdViewController.it = self
        ThirdViewController.API = ViewController.API
        ThirdViewController.selectedMsg = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = Message.allMessages[indexPath.row]
        ThirdViewController.selectedMsg = msg
        ThirdViewController.API.loadAllMessages(fromMessageId: msg.id)
        Response.allResponses = []
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "responses", sender: "batman")
        }
    }
    
    func editTopic(alert: UIAlertAction) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "editTopicContent", sender: "batman")
        }
    }
    
    func deleteTopic(alert: UIAlertAction) {

        //Do Action
        ThirdViewController.API.deleteTopic(topic: SecondViewController.selectedTopic)
        self.performSegue(withIdentifier: "backToSecondFromDeleteTopic", sender: "123")
    }
    
    func addMessage(alert: UIAlertAction) {
        print("ToSegueAddMessage")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "addMessage", sender: "batman")
        }

    }
    
    @IBAction func unwindToThirdView(segue: UIStoryboardSegue) {
        print(segue.identifier!)
    }
    
    func segueTo(identifier: String) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: "batman")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Message.allMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        cell.node = Message.allMessages[indexPath.row]
        return cell
    }
}
