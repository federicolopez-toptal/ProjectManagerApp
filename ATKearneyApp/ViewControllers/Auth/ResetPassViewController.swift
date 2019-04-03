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

    // MARK: - Form validation
    func validateForm() -> Bool {
        if(emailTextField.text!.isEmpty) {
            ALERT(title_ERROR, text_EMPTY_FIELDS, viewController: self)
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Button actions
    @IBAction func resetPassButtonTap(_ sender: UIButton) {
        if(validateForm()) {
            showLoading(true)
            
            FirebaseManager.shared.resetPassword(email: emailTextField.text!) { (error) in
                if(error==nil) {
                    //ALERT(title_SUCCES, text_EMAIL_SENT, viewController: self)
                    
                    self.performSegue(withIdentifier: "gotoConfirmation", sender: self)
                } else {
                    var text = ""
                    let errorCode = ERROR_CODE(error)
                    
                    switch(errorCode) {
                    case 17011:
                        text = text_EMAIL_NOT_FOUND
                    case 17008:
                        text = text_INVALID_EMAIL
                    default:
                        text = text_GENERIC_ERROR
                    }
                    ALERT(title_ERROR, text, viewController: self)
                }
                
                self.showLoading(false)
            }
        }
        
    }
    
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
