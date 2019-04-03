//
//  UserDetailsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 14/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class UserDetailsViewController: BaseViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var officerView: UIView!
    @IBOutlet weak var projectOfficerSwitch: UISwitch!
    @IBOutlet weak var officerStatusLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var editUserButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var profileInProject = false
    var officerRoleEditable = false
    var canEditMyProfile = false
    var userID: String = ""
    
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = SelectedUser.shared.userID
        officerView.backgroundColor = UIColor.white
        photoImageView.setCircular()
        projectOfficerSwitch.backgroundColor = UIColor.darkGray
        projectOfficerSwitch.layer.cornerRadius = 16.0;

        
        officerView.isHidden = true
        editUserButton.isHidden = true
        changePasswordButton.isHidden = true
        logoutButton.isHidden = true
        
        if(canEditMyProfile) {
            editUserButton.isHidden = false
            changePasswordButton.isHidden = false
            logoutButton.isHidden = false
        }
        
        if(profileInProject) {
            officerView.isHidden = false
            projectOfficerSwitch.isOn = SelectedProject.shared.hasOfficer(userID: userID)
            
            if(projectOfficerSwitch.isOn) {
                officerStatusLabel.text = "YES"
            } else {
                officerStatusLabel.text = "NO"
            }
            
            if(officerRoleEditable) {
                projectOfficerSwitch.isHidden = false
                officerStatusLabel.isHidden = true
            } else {
                projectOfficerSwitch.isHidden = true
                officerStatusLabel.isHidden = false
            }
        }
        projectOfficerSwitch.isEnabled = officerRoleEditable
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(SelectedUser.shared.admin) {
            userTypeLabel.text = "Admin"
        } else {
            if( IS_ATK_MEMBER(email: SelectedUser.shared.email) ) {
                userTypeLabel.text = "ATK member"
            } else {
                userTypeLabel.text = "Client"
            }
        }
        
        nameLabel.text! = SelectedUser.shared.name
        emailLabel.text! = SelectedUser.shared.email
        phoneLabel.text! = SelectedUser.shared.phone
        roleLabel.text = SelectedUser.shared.role
        skillsLabel.text = SelectedUser.shared.skills
        
        if let roleText = roleLabel.text {
            if(roleText.isEmpty) {
                roleLabel.text = "..."
            }
        } else {
            roleLabel.text = "..."
        }
        if let skillsText = skillsLabel.text {
            if(skillsText.isEmpty) {
                skillsLabel.text = "..."
            }
        } else {
            skillsLabel.text = "..."
        }
        
        FirebaseManager.shared.userPhoto(userID: SelectedUser.shared.userID, lastUpdate: SelectedUser.shared.photoLastUpdate, to: photoImageView)
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
        showLoading(true)
        FirebaseManager.shared.removeDeviceFromCurrentUser {
            self.showLoading(false)
            
            FirebaseManager.shared.logout()
            
            let loginVC = self.navigationController?.viewControllers.first as! LoginViewController
            loginVC.emailTextField.text = ""
            loginVC.passwordTextField.text = ""
            self.navigationController?.popToViewController(loginVC, animated: true)
        }
    }
    
}