//
//  FirebaseManager.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    private let USERS = "users_v2"
    private let PROJECTS = "projects_v2"
    
    // MARK: - Users
    func createUser(email: String, password: String, info:[String: Any], callback: @escaping (Error?) ->() ) {
        CurrentUser.shared.empty()
        Auth.auth().createUser(withEmail: email, password: password){ (user, error) in
            if(error != nil) {
                callback(error)
            } else {
                if let userID = Auth.auth().currentUser?.uid {
                    let DBref = Database.database().reference()
                    DBref.child(self.USERS).child(userID).child("info").setValue(info)
                    CurrentUser.shared.fillWith(userID: userID, info: info)
                    
                    callback(nil)
                }
            }
        }
        
    }
    
    func login(email: String, password: String, callback: @escaping (NSDictionary?, Error?) -> () ) {
        CurrentUser.shared.empty()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if(error != nil) {
                callback(nil, error)
            } else if (user != nil) {
                if let userID = user?.user.uid {
                    let DBref = Database.database().reference()
                    
                    DBref.child(self.USERS).child(userID).child("info").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let userDict = snapshot.value as? NSDictionary {
                            CurrentUser.shared.fillWith(userID: userID, info: userDict as! [String: Any])                            
                            callback(userDict, nil)
                        } else {
                            callback(nil, nil)
                        }
                    }) { (error) in
                        callback(nil, error)
                    }
                    
                }
 
            }
        }
        
    }
    
    func autoLogin(callback: @escaping (Error?) ->() ) {
        CurrentUser.shared.empty()
        if let userID = Auth.auth().currentUser?.uid {
            getUser(userID: userID) { (userDict, error) in
                if(error != nil) {
                    callback(error)
                } else {
                    CurrentUser.shared.fillWith(userID: userID, info: userDict as! [String: Any])
                    callback(nil)
                }
            }
        } else {
            callback(nil)
        }
    }
    
    func logout() {
        CurrentUser.shared.empty()
        try! Auth.auth().signOut()
    }
    
    
    func getUser(userID: String, callback: @escaping (NSDictionary?, Error?) -> () ) {
        let DBref = Database.database().reference()
        
        DBref.child(USERS).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? NSDictionary {
                callback(userDict, nil)
            } else {
                callback(nil, nil)
            }
        }) { (error) in
            callback(nil, error)
        }
    }
    
    func getAllUsers(callback: @escaping (NSDictionary?, Error?) -> ()) {
        let DBref = Database.database().reference()
        
        DBref.child(USERS).observeSingleEvent(of: .value, with: { (snapshot) in
            if let usersDict = snapshot.value as? NSDictionary {
                callback(usersDict, nil)
            } else {
                callback(nil, nil)
            }
        }) { (error) in
            callback(nil, error)
        }
    }
    
    func getUsers(userIDs: Set<String>, callback: @escaping ([NSDictionary]?) -> ()) {
        let DBref = Database.database().reference()
        let dispatchGroup = DispatchGroup()
        var result = [NSDictionary]()
        
        if(userIDs.isEmpty) {
            callback(result)
            return
        }
        
        for userID in userIDs {
            dispatchGroup.enter()
            
            DBref.child(USERS).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()) {
                    let newDict = [
                        "id": snapshot.key,
                        "content": snapshot.value as! NSDictionary
                        ] as [String : Any]
                    
                    result.append(newDict as NSDictionary)
                }
                
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            callback(result)
        })
    }
    
    // MARK: - Projects
    //func createProject(values: [String: Any], callback: @escaping (Error?) -> () ) {
    func createProject(info: [String: String], users: [String: Bool], officers: [String: Bool], callback: @escaping (Error?) -> () ) {
        let DBref = Database.database().reference()
        
        let newItemContent = [
            "info": info,
            "users": users,
            "officers": officers
        ] as [String: Any]
        
        let newProject = DBref.child(PROJECTS).childByAutoId()
        newProject.setValue(newItemContent){ (error, ref) in
            if let projectID = ref.key {
                let dispatchGroup = DispatchGroup()
                
                for (keyUserID, _) in users {
                    dispatchGroup.enter()
                    
                    DBref.child(self.USERS).child(keyUserID).child("projects").observeSingleEvent(of: .value, with: { (snapshot) in
                        if(snapshot.exists()) {
                            var userCurrentProjects = snapshot.value as! [String: Bool]
                            userCurrentProjects[projectID] = true   // add this new project to user

                            DBref.child(self.USERS).child(keyUserID).child("projects").setValue(userCurrentProjects)
                        } else {
                            let userCurrentProjects = [
                                projectID: true
                            ]
                            
                            DBref.child(self.USERS).child(keyUserID).child("projects").setValue(userCurrentProjects)
                        }
                        
                        dispatchGroup.leave()
                    })
                }
                
                dispatchGroup.notify(queue: .main, execute: {
                    callback(error)
                })
            } else {
                callback(error)
            }
        }
    }
    
    
    func getAllProjects(callback: @escaping ([NSDictionary]?, Error?) -> ()) {
        var result = [NSDictionary]()
        let DBref = Database.database().reference()
        
        DBref.child(PROJECTS).observeSingleEvent(of: .value, with: { (snapshot) in
            if(!snapshot.exists()) {
                callback([NSDictionary](), nil)
                return
            }
            
            let projectsDict = snapshot.value as! [String: Any]
            for (keyProjectID, value) in projectsDict {
                let newDict = [
                    "id": keyProjectID,
                    "content": value as! NSDictionary
                    ] as [String : Any]
                
                result.append(newDict as NSDictionary)
            }
            
            callback(result, nil)
        }) { (error) in
            callback(nil, error)
        }
    }
    
    
    func getUserProjects(userID: String, callback: @escaping ([NSDictionary]?, Error?) -> ()) {
        let DBref = Database.database().reference()
        
        DBref.child(USERS).child(userID).child("projects").observeSingleEvent(of: .value, with: { (snapshot) in
            if(!snapshot.exists()) {
                callback([NSDictionary](), nil)
                return
            }
            
            if let projectsDict = snapshot.value as? [String: Bool] {
                let dispatchGroup = DispatchGroup()
                var result = [NSDictionary]()
                
                for (keyProjectID, _) in projectsDict {
                    dispatchGroup.enter()
                    
                    DBref.child(self.PROJECTS).child(keyProjectID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if(snapshot.exists()) {
                            let newDict = [
                                "id": snapshot.key,
                                "content": snapshot.value as! NSDictionary
                                ] as [String : Any]
                            
                            result.append(newDict as NSDictionary)
                        }
                        
                        dispatchGroup.leave()
                    })
                }
                
                dispatchGroup.notify(queue: .main, execute: {
                    callback(result, nil)
                })
                
            }
        }) { (error) in
            callback(nil, error)
        }
    }
    
    //func editProject(projectID: String, values: [String: Any], usersAdded: Set<String>, usersRemoved: Set<String>, callback: @escaping (Error?) -> () ) {
    
    func editProject(projectID: String, info: [String: String], users: [String: Bool], officers: [String: Bool],
                     usersAdded: Set<String>, usersRemoved: Set<String>,
                     callback: @escaping (Bool) -> () )
    {
        
        let DBref = Database.database().reference()
        
        DBref.child(PROJECTS).child(projectID).child("info").setValue(info)
        DBref.child(PROJECTS).child(projectID).child("users").setValue(users)
        DBref.child(PROJECTS).child(projectID).child("officers").setValue(officers)
        
        let dispatchGroup = DispatchGroup()
        
        // users added
        for userID in usersAdded {
            dispatchGroup.enter()
            
            DBref.child(self.USERS).child(userID).child("projects").observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()) {
                    var userCurrentProjects = snapshot.value as! [String: Bool]
                    userCurrentProjects[projectID] = true   // add this new project to user
                    
                    DBref.child(self.USERS).child(userID).child("projects").setValue(userCurrentProjects)
                } else {
                    let userCurrentProjects = [
                        projectID: true
                    ]
                    
                    DBref.child(self.USERS).child(userID).child("projects").setValue(userCurrentProjects)
                }
                
                dispatchGroup.leave()
            })
        }
        
        // Users removed
        for userID in usersRemoved {
            dispatchGroup.enter()
            DBref.child(self.USERS).child(userID).child("projects").child(projectID).removeValue()
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            callback(true)
        })
        
    }
    
    
    
    
    
}
