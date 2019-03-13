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
    
    func fillWith(userID: String, values: [String: Any]) {
        authenticated = true
        self.userID = userID
        admin = values["admin"] as! Bool
        email = values["email"] as! String
        name = values["name"] as! String
        phone = values["phone"] as! String
    }
    
    func empty() {
        authenticated = false
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
    }
    
    
    
    
    func setValues(_ values: [String: Any]) {
        admin = values["admin"] as! Bool
        email = values["email"] as! String
        name = values["name"] as! String
        phone = values["phone"] as! String
    }
    
    func trace() {
        print(userID, email, name)
    }
    
}
