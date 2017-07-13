//
//  tweetCellTableViewCell.swift
//  d04_tweeter
//
//  Created by Thomas LE MEUR on 6/16/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ttext: UITextView!

    var note : Tweet? {
        didSet {
            if let n = note {
                name?.text = n.name
                date?.text = n.date
                ttext?.text = n.text
            }
        }
    }
}
