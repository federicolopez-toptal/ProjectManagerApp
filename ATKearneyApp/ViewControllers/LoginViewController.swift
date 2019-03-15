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
        
        FirebaseManager.shared.autoLogin{ (success, error) in
            if(error==nil && success) {
                MyUser.shared.trace()
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
                    MyUser.shared.trace()
                    self.performSegue(withIdentifier: "gotoProjects", sender: self)
                }
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
