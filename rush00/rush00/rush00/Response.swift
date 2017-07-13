//
//  Response.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation
import UIKit

struct Response {
    var id : Int
    var content: String
    var authorLogin: String
    var date: String
    
    static var allResponses: [Response] = []
}

class ResponseCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var data: UILabel! //do not remove cause Crash
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UITextView!
    
    
    var node: Response? {
        didSet {
            if let n = node {
                content.text = n.content.replacingOccurrences(of: "\r", with: "")
                author.text = n.authorLogin
                date.text = n.date
            }
        }
    }
}
