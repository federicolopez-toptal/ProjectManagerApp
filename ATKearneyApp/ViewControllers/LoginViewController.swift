//
//  LoginViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        FirebaseManager.shared.autoLogin{ (error) in
            if(error == nil && CurrentUser.shared.authenticated) {
                self.loading.stopAnimating()
                CurrentUser.shared.trace()
                self.performSegue(withIdentifier: "gotoProjects", sender: self)
            } else {
                //ADD: ALERT error auth
            }
        }
        */
 
        // Standard login
        let email = "johnDoe@gmail.com"
        let pass = "gato123"
        FirebaseManager.shared.login(email: email, password: pass) { (user, error) in
            if(error==nil) {
                self.loading.stopAnimating()
                CurrentUser.shared.trace()
                self.performSegue(withIdentifier: "gotoProjects", sender: self)
            }
        }
    }
    
    
    
    
    
    
    func test() {
        
         // Create user
         let email = "janeDoe@gmail.com"
         let pass = "gato123"
         let fields = [
         "admin": false,
         "name": "Jane Doe",
         "phone": "123",
         "email": email
         ] as [String : Any]
         
         FirebaseManager.shared.createUser(email: email, password: pass, values: fields) { (error) in
            if(error==nil) {
                CurrentUser.shared.trace()
            }
            
         }
        
        
        
        
        /*
         // Login
         let email = "carlos.lopez@toptal.com"
         let pass = "gato123"
         FirebaseManager.shared.login(email: email, password: pass) { (user, error) in
            CurrentUser.shared.trace()
         }
 */
    }
    
}
