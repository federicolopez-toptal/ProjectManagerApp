//
//  CurrentUser.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class MyUser {
    
    static let shared = MyUser()
    
    var userID: String
    var admin: Bool
    var email: String
    var name: String
    var phone: String
    
    init() {
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
    }
    
    func fillWith(userID: String, info: [String: Any]) {
        self.userID = userID
        admin = info["admin"] as! Bool
        email = info["email"] as! String
        name = info["name"] as! String
        phone = info["phone"] as! String
    }
    
    func empty() {
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
    }
    
    func trace() {
        print(">>> CURRENT USER:", userID, email, name)
    }
    
}
