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
    
    var role: String
    var skills: String
    
    init() {
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
        role = ""
        skills = ""
    }
    
    func fillWith(userID: String, info: [String: Any]) {
        self.userID = userID
        admin = info["admin"] as! Bool
        email = info["email"] as! String
        name = info["name"] as! String
        phone = info["phone"] as! String
        
        // Optional fields
        if let role = info["role"] as? String {
            self.role = role
        } else {
            self.role = ""
        }
        
        if let skills = info["skills"] as? String {
            self.skills = skills
        } else {
            self.skills = ""
        }
    }
    
    func empty() {
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
        role = ""
        skills = ""
    }
    
    func trace() {
        print(">>> CURRENT USER:", userID, email, name)
    }
    
}
