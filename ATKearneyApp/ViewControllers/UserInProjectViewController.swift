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
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //editView.backgroundColor = UIColor.white
        editView.isHidden = !editingUser
        nameLabel.text! = CurrentSelection.shared.user.name
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
