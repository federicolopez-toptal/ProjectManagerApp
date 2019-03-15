//
//  SelectedUser.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 15/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class SelectedUser {
    static let shared = SelectedUser()
    
    var userID = ""
    var email  = ""
    var name = ""
    var phone = ""
    
    func empty() {
        userID = ""
        email = ""
        name = ""
        phone = ""
    }
}
