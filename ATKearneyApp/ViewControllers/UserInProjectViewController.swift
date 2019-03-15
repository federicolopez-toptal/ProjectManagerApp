//
//  UserInProjectViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 14/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class UserInProjectViewController: BaseViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var officerView: UIView!
    @IBOutlet weak var projectOfficerSwitch: UISwitch!
    
    var officerEditable = false
    var userID: String = ""
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = SelectedUser.shared.userID
        officerView.backgroundColor = UIColor.white
        nameLabel.text! = SelectedUser.shared.name
        
        officerView.isHidden = true
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
    
    
}
