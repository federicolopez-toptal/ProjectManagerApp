//
//  CurrentSelection.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

struct Project {
    var projectID = ""
    var name = ""
    var description = ""
    var users = Set<String>()
    var officers = Set<String>()
    
    mutating func empty() {
        projectID = ""
        name = ""
        description = ""
        users = Set<String>()
        officers = Set<String>()
    }
}

struct User {
    var userID = ""
    var email  = ""
    var name = ""
    var phone = ""
    
    mutating func empty() {
        userID = ""
        email = ""
        name = ""
        phone = ""
    }
}



class CurrentSelection {
    static let shared = CurrentSelection()
    var project = Project()
    var user = User()
}
