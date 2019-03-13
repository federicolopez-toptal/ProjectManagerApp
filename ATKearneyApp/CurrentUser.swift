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
    
    func setValues(_ values: [String: Any]) {
        admin = values["admin"] as! Bool
        email = values["email"] as! String
        name = values["name"] as! String
        phone = values["phone"] as! String
    }
    
}
