//
//  APIController.swift
//  d04_tweeter
//
//  Created by Thomas LE MEUR on 6/16/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation

class APIController {
    weak var delegate : APITwitterDelegate?
    let token : String
    
    init (del: APITwitterDelegate?, tok: String) {
        delegate = del
        token = tok
    }
    
    func doRequest (search: String, view: ViewController) {
        let addr = "https://api.twitter.com/1.1/search/tweets.json?q=" + search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)! + "&count=100&lang=fr"
        let url = URL(string: addr)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d, options: []) as? [String: Any] {
                        if let tweets = dic["statuses"] as? NSArray {
                            Tweet.allTweets = []
                            for tweet in tweets {
                                if let dic_tweet = tweet as? [String: Any] {
                                    if let name = dic_tweet["user"] as? [String: Any] {
                                        let date = dic_tweet["created_at"] as? String
                                        let splits = date?.components(separatedBy: " ")
                                        var s_date = ""
                                        if let split = splits {
                                            s_date += "\(split[0]) \(split[1]) \(split[2]) \(split[3])"
                                        }
                                        Tweet.allTweets.append(Tweet(name: name["name"] as! String, text: dic_tweet["text"] as! String, date: s_date))
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                view.table.reloadData()
                            }
                            //for tweet in Tweet.allTweets {
                             ///   print(tweet)
                            //}
                        }
                    }
                } catch (let err) {
                    DispatchQueue.main.async {
                        view.error(err: err)
                    }
                }
            }
        })
        task.resume()
    }
}
