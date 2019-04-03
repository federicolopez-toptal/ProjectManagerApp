//
//  ResetPassConfirmationViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 03/04/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class ResetPassConfirmationViewController: BaseViewController {

    // MARK: - Buttion actions
    @IBAction func AcceptButtonTap(_ sender: UIButton) {
        for VC in self.navigationController!.viewControllers {
            if(VC is LoginViewController) {
                self.navigationController?.popToViewController(VC, animated: true)
                break
            }
        }
    }
    
}
