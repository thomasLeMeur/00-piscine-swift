//
//  UserInfos.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation

struct UserInfos: CustomStringConvertible {
    var login: String
    var id: Int
    var code: String
    var token: String
    var imgurl: String
    
    var description : String {
        return "login: \(login) / id: \(id) / code: \(code) / token: \(token) / img: \(imgurl)"
    }
}
