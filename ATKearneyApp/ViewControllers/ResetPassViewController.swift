//
//  ResetPassViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 15/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class ResetPassViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollView, bottomContraint: bottomConstraint)
    }

    // MARK: - Button actions
    @IBAction func resetPassButtonTap(_ sender: UIButton) {
        FirebaseManager.shared.resetPassword(email: emailTextField.text!) { (error) in
            if(error==nil) {
                print("Email sent!")
            }
        }
    }
    
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
