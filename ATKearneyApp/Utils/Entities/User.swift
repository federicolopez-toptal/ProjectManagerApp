//
//  User.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 18/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

struct User {
    
    var userID = ""
    var admin = false
    var email = ""
    var name = ""
    var phone = ""
    
    var company: String?
    var role: String?
    var skills: String?
    var photoLastUpdate: String?
    var deviceToken: String?
    

    // MARK: - Edit info
    mutating func reset() {
        userID = ""
        admin = false
        email = ""
        name = ""
        phone = ""
        
        company = nil
        role = nil
        skills = nil
        photoLastUpdate = nil
        deviceToken = nil
    }
    
    mutating func fillWith(info: NSDictionary) {
        let userID = info["id"] as! String
        let content = info["content"] as! NSDictionary
        let info = content["info"] as! [String: Any]
        
        self.userID = userID
        admin = info["admin"] as! Bool
        email = info["email"] as! String
        name = info["name"] as! String
        phone = info["phone"] as! String
        
        // Optional fields
        company = info["company"] as? String
        role = info["role"] as? String
        skills = info["skills"] as? String
        photoLastUpdate = info["photoLastUpdate"] as? String
        deviceToken = info["deviceToken"] as? String
    }
    
    mutating func fillWith(userID: String, info: [String: Any]) {
        self.userID = userID
        admin = info["admin"] as! Bool
        email = info["email"] as! String
        name = info["name"] as! String
        phone = info["phone"] as! String
        
        // Optional fields
        company = info["company"] as? String
        role = info["role"] as? String
        skills = info["skills"] as? String
        photoLastUpdate = info["photoLastUpdate"] as? String
        deviceToken = info["deviceToken"] as? String
    }
    
    // MARK: - misc
    func trace() {
        print("####################################################################################")
        print(">>> CURRENT USER:", userID, email, name)
    }
    
    func traceAll() {
        trace()
        
        var text = phone
        if let role = self.role {
            text += " \(role)"
        }
        if let skills = self.skills {
            text += " \(skills)"
        }
        print(text)
        
        if let photoLastUpdate = self.photoLastUpdate {
            print("Photo last update: ", photoLastUpdate)
        }
        
        if(admin){
            print("user IS ADMIN")
        } else {
            print("user is not admin")
        }
        
        print("####################################################################################")
    }
    
    
    
}
