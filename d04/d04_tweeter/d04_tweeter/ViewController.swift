//
//  ViewController.swift
//  d04_tweeter
//
//  Created by Thomas LE MEUR on 6/16/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APITwitterDelegate {
    var twitter : APIController? = nil
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var search: UITextField!
    
    @IBAction func searchAction(_ sender: Any) {
        if let s = search.text {
            if s != "" {
                self.twitter?.doRequest(search: s, view: self)
                search.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let CUSTOMER_KEY = "bJ5D4z3OTbctkRiOr6iWvDXJE"
        let CUSTOMER_SECRET = "1Tz9WgunEeU0Fz1LlU1i9bJLbbWfRY93AD4McO22Fl9onicTLh"
        let BEARER = NSString(data: ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue: 0)), encoding: String.Encoding.utf8.rawValue)!
        
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic \(BEARER)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self.twitter = APIController(del: self, tok: "\(dic["access_token"]!)")
                        self.twitter?.doRequest(search: "ecole 42", view: self)
                    }
                    
                } catch (let err) {
                    self.error(err: err)
                }
            }
        })
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tweet.allTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        cell.note = Tweet.allTweets[indexPath.row]
        return cell
    }
    

    func treatTweet (tab: [Tweet]) {
    }

    func error (err: Error) {
        let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

