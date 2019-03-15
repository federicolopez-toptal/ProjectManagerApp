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
    
    // MARK: - misc
    func validateForm() -> Bool {
        if(!nameTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !phoneTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Button actions
    @IBAction func createAccountButtonTap(_ sender: UIButton) {
        // Create user
        let info = [
            "admin": false,
            "name": nameTextField.text!,
            "phone": phoneTextField.text!,
            "email": emailTextField.text!
            ] as [String : Any]
        
        FirebaseManager.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, info: info) { (error) in
            if(error==nil) {
                MyUser.shared.trace()
                self.performSegue(withIdentifier: "gotoProjects", sender: self)
            }
            
        }
    }
    
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
