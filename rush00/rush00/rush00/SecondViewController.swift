//
//  ViewController.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static var API : ApiController!
    static var it: SecondViewController!
    static var selectedTopic: Topic!
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SecondViewController.it = self
        SecondViewController.API = ViewController.API
        SecondViewController.API.loadAllTopics()
        SecondViewController.selectedTopic = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segueToMsg(_ sender: Any) {
        Message.allMessages = []
        self.segueToMessages()
    }
    
    func segueToMessages() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "messages", sender: "batman")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let topic = Topic.allTopics[indexPath.row]
        SecondViewController.API.loadAllMessages(fromTopicId: topic.id)
        SecondViewController.selectedTopic = topic
        self.segueToMessages()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topic.allTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicCell
        cell.node = Topic.allTopics[indexPath.row]
        if (Topic.allTopics.count > 50 && indexPath.row == Topic.allTopics.count - 80) {
            SecondViewController.API.loadnextTopics(lastIndex: Topic.allTopics.count)
        }
        return cell
    }
    
    @IBAction func unwindToSecondView(segue: UIStoryboardSegue) {
        print(segue.identifier!)
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Actions", message: "Que Voulez-vous Faire?", preferredStyle: UIAlertControllerStyle.alert)
        
        if (SecondViewController.API.user != nil) {

            alert.addAction(UIAlertAction(
                title: "Creer un topic",
                style: UIAlertActionStyle.default,
                handler: addTopic
            ))
        }

        alert.addAction(UIAlertAction(
            title: "Rien finalement..",
            style: UIAlertActionStyle.default,
            handler: nil
        ))
        
        SecondViewController.it.present(alert, animated: true, completion: nil)
    }
    
    func addTopic(alert: UIAlertAction) {
        performSegue(withIdentifier: "addTopic", sender: "batman")
    }
}
