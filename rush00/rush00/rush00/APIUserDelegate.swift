//
//  APIUserDelegate.swift
//  rush00
//
//  Created by Thomas LE MEUR on 6/17/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import Foundation

protocol APIUserDelegate {
    func authenticate(code: String)
    func disconnect(user: UserInfos)
}
