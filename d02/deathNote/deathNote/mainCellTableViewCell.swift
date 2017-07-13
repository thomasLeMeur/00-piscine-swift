//
//  mainCellTableViewCell.swift
//  deathNote
//
//  Created by Thomas LE MEUR on 6/14/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class mainCellTableViewCell: UITableViewCell {
    @IBOutlet weak var daeth: UILabel!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var death: UILabel!

    var note : (String, String, String)? {
        didSet {
            if let n = note {
                name?.text = n.0
                date?.text = n.1
                death?.numberOfLines = n.2.components(separatedBy: "\n").count
                death?.text = n.2
                
            }
        }
    }
}
