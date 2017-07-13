//
//  FourthViewController.swift
//  rush00
//
//  Created by Julian SCARPONE on 6/18/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

class FourthViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static var API: ApiController!
    static var it: FourthViewController!
    static var responseSelected: Response!
    
    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        FourthViewController.it = self
        FourthViewController.API = ViewController.API
        FourthViewController.responseSelected = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FourthViewController.responseSelected = Response.allResponses[indexPath.row]
        self.segueToUniqueResponse()
    }
    
    func segueToUniqueResponse() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "uniqueResponse", sender: "batman")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Response.allResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "responseCell") as! ResponseCell
        cell.node = Response.allResponses[indexPath.row]
        return cell
    }
    
    @IBAction func rightBtnAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Actions", message: "Que Voulez-vous Faire?", preferredStyle: UIAlertControllerStyle.alert)
        
        if (FourthViewController.API.user!.login == ThirdViewController.selectedMsg.authorLogin) {
            alert.addAction(UIAlertAction(
                title: "Editer le message",
                style: UIAlertActionStyle.default,
                handler: editMessage
            ))
            
            alert.addAction(UIAlertAction(
                title: "Supprimer le Message",
                style: UIAlertActionStyle.default,
                handler: deleteMessage
            ))
        }
        
        alert.addAction(UIAlertAction(
            title: "Rien finalement..",
            style: UIAlertActionStyle.default,
            handler: nil
        ))
        
        FourthViewController.it.present(alert, animated: true, completion: nil)
    }
    
    func editMessage(alert: UIAlertAction) {
        self.performSegue(withIdentifier: "editMsg", sender: "bane")
    }
    
    func deleteMessage(alert: UIAlertAction) {
        
        //Do Action
        FourthViewController.API.deleteMessage(message: ThirdViewController.selectedMsg)
        self.performSegue(withIdentifier: "backToThirdFromFourth", sender: "123")
    }
    
}
