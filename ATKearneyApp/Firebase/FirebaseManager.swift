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
    
    // MARK: - Users
    func createUser(email: String, password: String, values:[String: Any], callback: @escaping (Error?) ->() ) {
        Auth.auth().createUser(withEmail: email, password: password){ (user, error) in
            if(error != nil) {
                callback(error)
            } else {
                if let userID = Auth.auth().currentUser?.uid {
                    let DBref = Database.database().reference()
                    
                    DBref.child(self.USERS).child(userID).setValue(values)
                    CurrentUser.shared.userID = userID
                    CurrentUser.shared.setValues(values)
                    
                    callback(nil)
                }
            }
        }
        
    }
    
    func login(email: String, password: String, callback: @escaping (NSDictionary?, Error?) -> () ) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if(error != nil) {
                callback(nil, error)
            } else if (user != nil) {
                if let userID = user?.user.uid {
                    let DBref = Database.database().reference()
                    
                    DBref.child(self.USERS).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let userDict = snapshot.value as? NSDictionary {
                            CurrentUser.shared.userID = userID
                            CurrentUser.shared.setValues(userDict as! [String : Any])
                            
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
    
    
    
    
    
    
    
    func getUser(userID: String, callback: @escaping (NSDictionary?, Error?) -> () ) {
        let DBref = Database.database().reference()
        
        DBref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? NSDictionary {
                callback(userDict, nil)
            } else {
                callback(nil, nil)
            }
        }) { (error) in
            callback(nil, error)
        }
    }
    
}
