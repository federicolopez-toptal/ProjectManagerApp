//
//  EditPasswordViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 18/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class EditPasswordViewController: BaseViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
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
        FirebaseManager.shared.editUserPassword(email: MyUser.shared.email, oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!){ (error) in
            
            if(error==nil) {
                print("YEAH!")
            }
        }
    }
    
}
