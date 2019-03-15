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
    @IBOutlet weak var officerView: UIView!
    @IBOutlet weak var projectOfficerSwitch: UISwitch!
    
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
        
        nameLabel.text! = SelectedUser.shared.name
        emailLabel.text! = SelectedUser.shared.email
        phoneLabel.text! = SelectedUser.shared.phone
        
        officerView.isHidden = true
        editUserButton.isHidden = true
        changePasswordButton.isHidden = true
        
        if(canEditInfo) {
            editUserButton.isHidden = false
            changePasswordButton.isHidden = false
        }
        
        if(officerEditable) {
            officerView.isHidden = false
            let userID = SelectedUser.shared.userID
            projectOfficerSwitch.isOn = SelectedProject.shared.officers.contains(userID)
        }
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func projectOfficerValueChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            SelectedProject.shared.officers.insert(userID)
        } else {
            SelectedProject.shared.officers.remove(userID)
        }
    }
    
    @IBAction func editButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoEdit", sender: self)
    }
    
    @IBAction func changePasswordTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoPass", sender: self)
    }
    
    
}
