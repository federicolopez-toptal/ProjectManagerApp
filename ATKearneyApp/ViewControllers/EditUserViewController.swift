//
//  EditUserViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 18/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class EditUserViewController: BaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var skillsTextField: UITextField!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text! = MyUser.shared.name
        emailTextField.text! = MyUser.shared.email
        phoneTextField.text! = MyUser.shared.phone
        roleTextField.text! = MyUser.shared.role
        skillsTextField.text! = MyUser.shared.skills
        
        emailTextField.isEnabled = false
    }

    
    // MARK: - Button actions
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        let info = [
            "admin": MyUser.shared.admin,
            "name": nameTextField.text!,
            "email": emailTextField.text!,
            "phone": phoneTextField.text!,
            "role": roleTextField.text!,
            "skills": skillsTextField.text!,
            ] as [String : Any]
        
        FirebaseManager.shared.editUser(userID: MyUser.shared.userID, info: info){ (error) in
            if(error==nil) {
                print("All ok")
                
                SelectedUser.shared.name = self.nameTextField.text!
                SelectedUser.shared.email = self.emailTextField.text!
                SelectedUser.shared.phone = self.phoneTextField.text!
                SelectedUser.shared.role = self.roleTextField.text!
                SelectedUser.shared.skills = self.skillsTextField.text!
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
