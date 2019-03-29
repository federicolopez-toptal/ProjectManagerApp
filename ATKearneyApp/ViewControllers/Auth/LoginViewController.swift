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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollView, bottomContraint: bottomConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(FirebaseManager.shared.shouldPerformAutoLogin()) {
            showLoading(true)
            FirebaseManager.shared.autoLogin{ (success, error) in
                if(error==nil && success) {
                    self.performSegue(withIdentifier: "gotoProjects", sender: self)
                }
                
                self.showLoading(false)
            }
        }
    }
    
    // MARK: - Form validation
    func validateForm() -> Bool {
        if(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            ALERT(title_ERROR, text_EMPTY_FIELDS, viewController: self)
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Button actions
    @IBAction func loginButtonTap(_ sender: UIButton) {
        if(validateForm()) {
            showLoading(true)
            FirebaseManager.shared.login(email: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if(error==nil) {
                    self.performSegue(withIdentifier: "gotoProjects", sender: self)
                } else {
                    var text = ""
                    let errorCode = ERROR_CODE(error)

                    switch(errorCode) {
                        case 17011, 17009:
                            text = text_LOGIN_ERROR
                        case 17008:
                            text = text_INVALID_EMAIL
                        default:
                            text = text_GENERIC_ERROR
                    }
                    ALERT(title_ERROR, text, viewController: self)
                }
                self.showLoading(false)
            }
        }
    }
    
    @IBAction func forgotPassButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoResetPass", sender: self)
    }
    
    @IBAction func createAccountButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoRegister", sender: self)
    }
    
    
}
