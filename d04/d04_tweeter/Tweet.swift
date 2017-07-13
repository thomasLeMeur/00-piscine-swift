//
//  Tweet.swift
//  d04_tweeter
//
//  Created by Thomas LE MEUR on 6/16/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible {
    static var allTweets : [Tweet] = []
    
    let name : String
    let text : String
    let date : String
    
    var description: String {
        return "Name: \(name) / Text: \(text) / Date: \(date)"
    }
}
