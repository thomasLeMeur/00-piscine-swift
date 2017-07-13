//
//  Message.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

struct Message {
    var id : Int
    var content: String
    var authorLogin: String
    var date: String
    var hasResponses: Bool
    
    static var allMessages: [Message] = []
}

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageAuthor: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var messageContent: UITextView!
    @IBOutlet weak var boolHasMessage: UILabel!
    var hasResponses: Bool = false
    
    var node: Message? {
        didSet {
            if let n = node {
                messageContent.text = n.content.replacingOccurrences(of: "\r", with: "")
                messageAuthor.text = n.authorLogin
                messageDate.text = n.date
                boolHasMessage.text = n.hasResponses ? "✉️" : ""
                hasResponses = n.hasResponses
            }
        }
    }
}
