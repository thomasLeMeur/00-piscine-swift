//
//  APITwitterDelegate.swift
//  d04_tweeter
//
//  Created by Thomas LE MEUR on 6/16/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class {
    func treatTweet (tab: [Tweet])
    func error (err: Error)
}
