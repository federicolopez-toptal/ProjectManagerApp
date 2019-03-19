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
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollview, bottomContraint: bottomConstraint)
        
        nameTextField.text! = MyUser.shared.name
        emailTextField.text! = MyUser.shared.email
        phoneTextField.text! = MyUser.shared.phone
        roleTextField.text = MyUser.shared.role
        skillsTextField.text = MyUser.shared.skills
        
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
        
        showLoading(true)
        FirebaseManager.shared.editUser(userID: MyUser.shared.userID, info: info){ (error) in
            if(error==nil) {
                let info = [
                    "admin": MyUser.shared.admin,
                    "name": self.nameTextField.text!,
                    "email": self.emailTextField.text!,
                    "phone": self.phoneTextField.text!,
                    "role": self.roleTextField.text as Any,
                    "skills": self.skillsTextField.text as Any
                    ] as [String: Any]

                MyUser.shared.fillWith(userID: MyUser.shared.userID, info: info)
                SelectedUser.shared = MyUser.shared
                
                self.navigationController?.popViewController(animated: true)
            } else {
                ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
            }
            
            self.showLoading(false)
        }
    }
    
}
