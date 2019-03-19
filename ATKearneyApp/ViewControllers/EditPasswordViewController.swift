//
//  EditPasswordViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 18/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class EditPasswordViewController: BaseViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Button actions
    @IBAction func backButonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        showLoading(true)
        FirebaseManager.shared.editUserPassword(email: MyUser.shared.email, oldPassword: currentPasswordTextField.text!, newPassword: newPasswordTextField.text!){ (error) in
            
            if(error==nil) {
                ALERT(title_SUCCES, text_PASSWORD_CHANGED, viewController: self)
            } else {
                ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
            }
            
            self.showLoading(false)
        }
    }
    
}
