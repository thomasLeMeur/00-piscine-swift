//
//  ApiController.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ApiController: APIUserDelegate {
    var AppToken : String = ""
    var user : UserInfos? = nil
    
    let UID = "b1b3535a06ffe7732aa6bf329a949b35da451437cada1edbcc5872b4e859abed"
    let SECRET = "a917df03b598faa26cacbf94808612bea0533cd28a1fdc04ae017d06d257be35"
    
    init () {
        
    }

    func authenticateUser() {
        let redirectUri = "rush00://rush00".addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
        let urlString = "https://api.intra.42.fr/oauth/authorize?client_id=\(UID)&redirect_uri=\(redirectUri!)&response_type=code&scope=public%20forum&state=coucou"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("url error")
        }
    }
    
    func authenticate(code: String) {
        let url = URL(string: "https://api.intra.42.fr/oauth/token?grant_type=authorization_code&client_id=\(UID)&client_secret=\(SECRET)&code=\(code)&redirect_uri=rush00://rush00")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let tok = dic["access_token"] as? String {
                            self.findUserInfos(code: code, token: tok)
                            //return
                        }
                    }
                    //error
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    func findUserInfos(code: String, token: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/me")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let log = dic["login"] as? String {
                            let img_url = dic["image_url"] as! String
                            let id = dic["id"] as! Int
                            self.user = UserInfos(login: log, id: id, code: code, token: token, imgurl: img_url)
                            print(self.user!)
                            //return
                        }
                    }
                    //error
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    func getAppToken() {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let tok = dic["access_token"] {
                            self.AppToken = tok as! String
                            print("App token : \(self.AppToken)")
                            //return
                        }
                    }
                    //error
                    
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }

    func loadAllTopics() {
        let url = URL(string: "https://api.intra.42.fr/v2/topics.json?page[size]=100&sort=-created_at")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.AppToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let arr : NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        Topic.allTopics = []
                        for topic in arr {
                            let topic_dir = topic as! [String: Any]
                            var date = topic_dir["created_at"] as! String
                            date = date.components(separatedBy: "T")[0] + " " + date.components(separatedBy: "T")[1].components(separatedBy: ".")[0]
                            let author = topic_dir["author"] as! [String: Any]
                            let message = topic_dir["message"] as! [String: Any]
                            let content = message["content"] as! [String: Any]
                            Topic.allTopics .append(Topic(
                                id: topic_dir["id"] as! Int,
                                name: topic_dir["name"] as! String,
                                content: content["markdown"] as! String,
                                authorLogin: author["login"] as! String, date: date
                            ))
                            //return
                        }
                        DispatchQueue.main.async {
                            SecondViewController.it.myTableView.reloadData()
                        }
                        //for topic in Topic.allTopics {
                        //    print(topic)
                        //}
                    }
                    //error
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    func loadnextTopics(lastIndex: Int) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics.json?page[size]=100&sort=-created_at&page[number]=\(lastIndex / 100 + 1)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.AppToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let arr : NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        for topic in arr {
                            let topic_dir = topic as! [String: Any]
                            var date = topic_dir["created_at"] as! String
                            date = date.components(separatedBy: "T")[0] + " " + date.components(separatedBy: "T")[1].components(separatedBy: ".")[0]
                            let author = topic_dir["author"] as! [String: Any]
                            let message = topic_dir["message"] as! [String: Any]
                            let content = message["content"] as! [String: Any]
                            Topic.allTopics .append(Topic(
                                id: topic_dir["id"] as! Int,
                                name: topic_dir["name"] as! String,
                                content: content["markdown"] as! String,
                                authorLogin: author["login"] as! String, date: date
                            ))
                            //return
                        }
                        DispatchQueue.main.async {
                            SecondViewController.it.myTableView.reloadData()
                        }
                        //for topic in Topic.allTopics {
                        //    print(topic)
                        //}
                    }
                    //error
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }

    func loadAllMessages(fromTopicId: Int) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(fromTopicId)/messages?page[size]=100&sort=created_at")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.AppToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let arr : NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        Message.allMessages = []
                        for message in arr {
                            let message_dir = message as! [String: Any]
                            var date = message_dir["created_at"] as! String
                            date = date.components(separatedBy: "T")[0] + " " + date.components(separatedBy: "T")[1].components(separatedBy: ".")[0]
                            let author = message_dir["author"] as! [String: Any]
                            var hasResponses = false
                            let arr_responses = message_dir["replies"] as! NSArray
                            if arr_responses.count > 0 {
                                hasResponses = true
                            }
                            Message.allMessages.append(Message(id: message_dir["id"] as! Int, content: message_dir["content"] as! String, authorLogin: author["login"] as! String, date: date, hasResponses: hasResponses))
                            //return
                        }
                        DispatchQueue.main.async {
                            ThirdViewController.it.myTableView.reloadData()
                        }
                        //for message in Message.allMessages {
                        //    print(message)
                        //}
                    }
                    //error
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    func loadAllMessages(fromMessageId: Int) {
        let url = URL(string: "https://api.intra.42.fr/v2/messages/\(fromMessageId)/messages?page[size]=100&sort=created_at")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.AppToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let arr : NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        Response.allResponses = []
                        for response in arr {
                            let response_dir = response as! [String: Any]
                            var date = response_dir["created_at"] as! String
                            date = date.components(separatedBy: "T")[0] + " " + date.components(separatedBy: "T")[1].components(separatedBy: ".")[0]
                            let author = response_dir["author"] as! [String: Any]
                            Response.allResponses.append(Response(id: response_dir["id"] as! Int, content: response_dir["content"] as! String, authorLogin: author["login"] as! String, date: date))
                            //return
                        }
                        DispatchQueue.main.async {
                            FourthViewController.it.myTableView.reloadData()
                        }
                        //for response in Response.allResponses {
                        //    print(response)
                        //}
                    }
                    //error
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    
    func deleteTopic(topic: Topic) {
        if SecondViewController.API.user == nil || topic.authorLogin != SecondViewController.API.user!.login {
            let alert = UIAlertController(title: "Error", message: "This topic is not your", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            SecondViewController.it.present(alert, animated: true, completion: nil)
            //perform segue
        } else {
            let url = URL(string: "https://api.intra.42.fr/v2/topics/\(topic.id)")
            var request = URLRequest(url: url!)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(SecondViewController.API.user!.token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if let err = error {
                    print(err)
                } else if data != nil {
                    SecondViewController.API.loadAllTopics()
                    //reload table of SecondView and perform segue
                }
            })
            task.resume()
        }
    }
    
    func deleteMessage(message: Message) {
        if SecondViewController.API.user == nil || message.authorLogin != SecondViewController.API.user!.login {
            let alert = UIAlertController(title: "Error", message: "This message is not yours", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            ThirdViewController.it.present(alert, animated: true, completion: nil)
            //perform segue
        } else {
            let url = URL(string: "https://api.intra.42.fr/v2/messages/\(message.id)")
            var request = URLRequest(url: url!)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(SecondViewController.API.user!.token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if let err = error {
                    print(err)
                } else if data != nil {
                    ThirdViewController.API.loadAllMessages(fromTopicId: SecondViewController.selectedTopic.id)
                    //reload table of ThirdView and perform segue
                }
            })
            task.resume()
        }
    }

    func createMessage(message: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(SecondViewController.selectedTopic.id)/messages")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(SecondViewController.API.user!.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"message\":{\"author_id\":\"\(SecondViewController.API.user!.id)\",\"content\":\"\(message)\"}}".data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            print("iCI ca passe ?")
            if let err = error {
                print(err)
            } else if data != nil {
                ThirdViewController.API.loadAllMessages(fromTopicId: SecondViewController.selectedTopic.id)
            }
        })
        task.resume()
    }
    
    func updateMessage(message: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/messages/\(ThirdViewController.selectedMsg.id)")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(SecondViewController.API.user!.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"message\":{\"author_id\":\"\(SecondViewController.API.user!.id)\",\"content\":\"\(message)\"}}".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if data != nil {
                ThirdViewController.API.loadAllMessages(fromTopicId: SecondViewController.selectedTopic.id)
            }
        })
        task.resume()
    }
    
    
    func createTopic(topicName: String, topicContent: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(SecondViewController.API.user!.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"topic\":{\"cursus_ids\":[\"1\"],\"kind\":\"normal\",\"language_id\":\"1\",\"name\":\"\(topicName)\",\"tag_ids\":[\"574\"],\"messages_attributes\":[{\"content\":\"\(topicContent)\",\"author_id\":\"\(SecondViewController.API.user!.id)\"}]}}".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if data != nil {
                SecondViewController.API.loadAllTopics()
            }
        })
        task.resume()
    }
    
    func updateTopic(topicName: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(SecondViewController.selectedTopic.id)")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(SecondViewController.API.user!.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"topic\":{\"name\":\"\(topicName)\"}}".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if data != nil {
                SecondViewController.API.loadAllTopics()
                //reload table of SecondView and perform segue
            }
        })
        task.resume()
    }
    
    
    func disconnect(user: UserInfos) {
        self.user = nil
    }
    
    func disconnect() {
        self.user = nil
    }
}
