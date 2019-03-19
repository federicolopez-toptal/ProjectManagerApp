//
//  UserDetailsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 14/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class UserDetailsViewController: BaseViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var officerView: UIView!
    @IBOutlet weak var projectOfficerSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var editUserButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    var officerEditable = false
    var canEditInfo = false
    var userID: String = ""
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = SelectedUser.shared.userID
        officerView.backgroundColor = UIColor.white
        
        officerView.isHidden = true
        editUserButton.isHidden = true
        changePasswordButton.isHidden = true
        logoutButton.isHidden = true
        
        if(canEditInfo) {
            editUserButton.isHidden = false
            changePasswordButton.isHidden = false
            logoutButton.isHidden = false
        }
        
        if(officerEditable) {
            officerView.isHidden = false
            projectOfficerSwitch.isOn = SelectedProject.shared.hasOfficer(userID: userID)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text! = SelectedUser.shared.name
        emailLabel.text! = SelectedUser.shared.email
        phoneLabel.text! = SelectedUser.shared.phone
        roleLabel.text = SelectedUser.shared.role
        skillsLabel.text = SelectedUser.shared.skills
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func projectOfficerValueChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            SelectedProject.shared.addUser(userID: userID, role: Project.OFFICER)
        } else {
            SelectedProject.shared.addUser(userID: userID, role: Project.REGULAR)
        }
    }
    
    @IBAction func editButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoEdit", sender: self)
    }
    
    @IBAction func changePasswordTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoPass", sender: self)
    }
    
    @IBAction func logoutButtonTap(_ sender: UIButton) {
        FirebaseManager.shared.logout()
        
        let loginVC = self.navigationController?.viewControllers.first as! LoginViewController
        loginVC.emailTextField.text = ""
        loginVC.passwordTextField.text = ""
        self.navigationController?.popToViewController(loginVC, animated: true)
    }
    
}
