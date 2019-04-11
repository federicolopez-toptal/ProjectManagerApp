//
//  UserDetailsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 14/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class UserDetailsViewController: BaseViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
 
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var officerView: UIView!
    @IBOutlet weak var projectOfficerSwitch: UISwitch!
    @IBOutlet weak var permissionsButton: BorderedButton!
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
        
        scrollview.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollview, bottomContraint: bottomConstraint)
        
        userID = SelectedUser.shared.userID
        officerView.backgroundColor = UIColor.white
        photoImageView.setCircular()
        projectOfficerSwitch.backgroundColor = COLOR_FROM_HEX("#842D2D")
        projectOfficerSwitch.layer.cornerRadius = 16.0;
        
        permissionsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        permissionsButton.superview?.bringSubviewToFront(permissionsButton)
        
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
                permissionsButton.setTitle("Project officer", for: .normal)
            } else {
                permissionsButton.setTitle("Regular user", for: .normal)
            }
            
            if(officerRoleEditable) {
                projectOfficerSwitch.isHidden = false
                permissionsButton.isHidden = true
            } else {
                projectOfficerSwitch.isHidden = true
                permissionsButton.isHidden = false
            }
        }
        projectOfficerSwitch.isEnabled = officerRoleEditable
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if(SelectedUser.shared.admin) {
            userTypeLabel.text = "ADMIN"
            userTypeLabel.textColor = COLOR_FROM_HEX("#BC1832")
        } else {
            if( IS_ATK_MEMBER(email: SelectedUser.shared.email) ) {
                userTypeLabel.text = "ATK MEMBER"
                userTypeLabel.textColor = COLOR_FROM_HEX("#842D2D")
            } else {
                userTypeLabel.text = "CLIENT"
                userTypeLabel.textColor = COLOR_FROM_HEX("#919191")
            }
        }
        
        
        nameLabel.text! = SelectedUser.shared.name
        emailLabel.text! = SelectedUser.shared.email
        phoneLabel.text! = SelectedUser.shared.phone
        roleLabel.text = SelectedUser.shared.role
        skillsLabel.text = SelectedUser.shared.skills
        
        if( IS_ATK_MEMBER(email: SelectedUser.shared.email) ) {
            companyLabel.text = "A.T. Kearney"
        } else {
            companyLabel.text = SelectedUser.shared.company
        }
        
        
        
        if let roleText = roleLabel.text {
            if(roleText.isEmpty) {
                roleLabel.text = "Unspecified"
                roleLabel.textColor = UIColor.lightGray
            }
        } else {
            roleLabel.text = "Unspecified"
            roleLabel.textColor = UIColor.lightGray
        }
        if let skillsText = skillsLabel.text {
            if(skillsText.isEmpty) {
                skillsLabel.text = "Unspecified"
                skillsLabel.textColor = UIColor.lightGray
            }
        } else {
            skillsLabel.text = "Unspecified"
            skillsLabel.textColor = UIColor.lightGray
        }
        if let companyText = companyLabel.text {
            if(companyText.isEmpty) {
                companyLabel.text = "Unspecified"
                companyLabel.textColor = UIColor.lightGray
            }
        } else {
            companyLabel.text = "Unspecified"
            companyLabel.textColor = UIColor.lightGray
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
        let title = "Logout"
        let msg = "Close current session?"
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            self.logout_step2()
        }
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
        }
        alert.addAction(noAction)
        
        self.present(alert, animated: true) {
        }
    }
    func logout_step2() {
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
