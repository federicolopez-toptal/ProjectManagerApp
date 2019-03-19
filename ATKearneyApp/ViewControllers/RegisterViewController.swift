//
//  RegisterViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 15/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollView, bottomContraint: bottomConstraint)
    }
    
    // MARK: - Form validation
    func validateForm() -> Bool {
        if(nameTextField.text!.isEmpty || emailTextField.text!.isEmpty || phoneTextField.text!.isEmpty && passwordTextField.text!.isEmpty) {
            ALERT(title_ERROR, text_EMPTY_FIELDS, viewController: self)
            return false
        } else {
            if(passwordTextField.text!.count<6) {
                ALERT(title_ERROR, text_SHORT_PASSWORD, viewController: self)
            }
            
            return true
        }
    }
    
    // MARK: - Button actions
    @IBAction func createAccountButtonTap(_ sender: UIButton) {
        if(validateForm()) {
            showLoading(true)
            
            let info = [
                "admin": false,
                "name": nameTextField.text!,
                "phone": phoneTextField.text!,
                "email": emailTextField.text!
                ] as [String : Any]
            
            FirebaseManager.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, info: info) { (error) in
                if(error==nil) {
                    self.performSegue(withIdentifier: "gotoProjects", sender: self)
                } else {
                    var text = ""
                    let errorCode = ERROR_CODE(error)
                    
                    switch(errorCode) {
                        case 17007:
                            text = text_EMAIL_IN_USE
                        default:
                            text = text_GENERIC_ERROR
                    }
                    ALERT(title_ERROR, text, viewController: self)
                }
                self.showLoading(false)
            }
            
        }
    }
    
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
