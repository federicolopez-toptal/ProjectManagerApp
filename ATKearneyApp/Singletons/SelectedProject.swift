//
//  SelectedProject.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class SelectedProject {
    static let shared = SelectedProject()
    
    var projectID = ""
    var name = ""
    var description = ""
    var users = Set<String>()
    var officers = Set<String>()
    
    func empty() {
        projectID = ""
        name = ""
        description = ""
        users = Set<String>()
        officers = Set<String>()
    }
}

