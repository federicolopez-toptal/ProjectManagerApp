//
//  FirebaseManager.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class FirebaseManager: NSObject {
    
    func getUser(userID: String, callback: @escaping (NSDictionary?, Error?) -> () ) {
        let DBref = FIRDatabase.database().reference()
        
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
