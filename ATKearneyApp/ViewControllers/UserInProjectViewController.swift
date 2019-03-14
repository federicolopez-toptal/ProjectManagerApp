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
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var projectOfficerSwitch: UISwitch!
    
    var editingUser = false
    var userID: String = ""
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = CurrentSelection.shared.user.userID
        editView.backgroundColor = UIColor.white
        nameLabel.text! = CurrentSelection.shared.user.name
        
        editView.isHidden = true
        if(editingUser) {
            editView.isHidden = false
            let userID = CurrentSelection.shared.user.userID
            projectOfficerSwitch.isOn = CurrentSelection.shared.project.officers.contains(userID)
        }
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func projectOfficerValueChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            CurrentSelection.shared.project.officers.insert(userID)
        } else {
            CurrentSelection.shared.project.officers.remove(userID)
        }
    }
    
    
}
