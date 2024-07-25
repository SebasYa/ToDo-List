//
//  User.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import Foundation


struct User: Codable {
    let id : String
    let name: String
    let email: String
    let joined: TimeInterval
    var profileImageUrl: String
}
