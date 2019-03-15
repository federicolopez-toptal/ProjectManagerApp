//
//  CurrentUser.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class CurrentUser {
    
    static let shared = CurrentUser()
    
    var authenticated: Bool
    var userID: String
    var admin: Bool
    var email: String
    var name: String
    var phone: String
    
    init() {
        authenticated = false
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
    }
    
    func fillWith(userID: String, info: [String: Any]) {
        authenticated = true
        self.userID = userID
        admin = info["admin"] as! Bool
        email = info["email"] as! String
        name = info["name"] as! String
        phone = info["phone"] as! String
    }
    
    func empty() {
        authenticated = false
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
    }
    
    func trace() {
        print(userID, email, name)
    }
    
}
