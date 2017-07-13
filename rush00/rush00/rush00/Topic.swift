//
//  Topic.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

struct Topic {
    var id : Int
    var name: String
    var content: String
    var authorLogin: String
    var date: String
    
    
    static var allTopics: [Topic] = []
}

class TopicCell: UITableViewCell {
    
    @IBOutlet weak var topicName: UILabel!
    @IBOutlet weak var topicContent: UITextView!
    @IBOutlet weak var topicAuthor: UILabel!
    @IBOutlet weak var topicDate: UILabel!
    
    var node: Topic? {
        didSet {
            if let n = node {
                topicName.text = n.name
                topicContent.text = n.content.replacingOccurrences(of: "\r", with: "")
                topicAuthor.text = n.authorLogin
                topicDate.text = n.date
            }
        }
    }
}

