//
//  LoginViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollView, bottomContraint: bottomConstraint)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseManager.shared.autoLogin{ (error) in
            
            if(error == nil && CurrentUser.shared.authenticated) {
                CurrentUser.shared.trace()
                self.performSegue(withIdentifier: "gotoProjects", sender: self)
            }
        }
        
        //FirebaseManager.shared.logout()
    }
    
    // misc
    func validateForm() -> Bool {
        if(!userTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Button actions
    @IBAction func loginButtonTap(_ sender: UIButton) {
        if(validateForm()) {
            FirebaseManager.shared.login(email: userTextField.text!, password: passwordTextField.text!) { (user, error) in
                if(error==nil) {
                    CurrentUser.shared.trace()
                    self.performSegue(withIdentifier: "gotoProjects", sender: self)
                }
            }
        }
    }
    
    @IBAction func forgotPassButtonTap(_ sender: UIButton) {
    }
    @IBAction func createAccountButtonTap(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
    func test() {
        /*
         // Create user
         let email = "janeDoe@gmail.com"
         let pass = "gato123"
         let info = [
         "admin": false,
         "name": "Jane Doe",
         "phone": "123",
         "email": email
         ] as [String : Any]
         
         FirebaseManager.shared.createUser(email: email, password: pass, info: info) { (error) in
            if(error==nil) {
                CurrentUser.shared.trace()
            }
            
         }
        */
        
        
        
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
