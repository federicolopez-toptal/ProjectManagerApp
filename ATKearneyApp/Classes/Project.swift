//
//  Project.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 18/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit


struct Project {
    
    static let OFFICER = "officer"
    static let REGULAR = "regular"
    
    var projectID = ""
    var name = ""
    var description = ""
    var users = [String: String]()
    
    
    // MARK: - Some queries
    func hasOfficer(userID: String) -> Bool {
        var found = false
        for (key, value) in users {
            if(key==userID && value==Project.OFFICER){
                found = true
                break
            }
        }
        
        return found
    }
    
    func roleForUser(userID: String) -> String {
        var result = Project.REGULAR
        
        for (key, value) in users {
            if(key==userID){
                result = value
                break
            }
        }
        
        return result
    }
    
    // MARK: - Edit info
    mutating func fillWith(dict: NSDictionary) {
        projectID = dict["id"] as! String
        
        let content = dict["content"] as! [String: Any]
        let info = content["info"] as! [String: String]
        
        name = info["name"]! as String
        description = info["description"]! as String
        users = content["users"] as! [String: String]
    }
    
    mutating func reset() {
        projectID = ""
        name = ""
        description = ""
        users = [String: String]()
    }
    
    mutating func addUser(userID: String, role: String) {
        users[userID] = role
    }
    
    // MARK: - misc
    static func subtract(from: [String: String], subtracting: [String: String]) -> [String: String] {
        var result = [String: String]()
        
        for (key, value) in from {
            if( subtracting[key] == nil ) {
                result[key] = value
            }
        }
        
        return result
    }
    
    
}
