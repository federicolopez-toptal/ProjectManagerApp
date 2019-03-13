//
//  CurrentSelection.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

struct basicProject {
    var projectID = ""
    var users = Set<String>()
    
    mutating func empty() {
        projectID = ""
        users = Set<String>()
    }
}

class CurrentSelection {
    
    static let shared = CurrentSelection()

    var project = basicProject()
}
