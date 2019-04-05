//
//  SurveyThanksViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 04/04/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class SurveyThanksViewController: BaseViewController {

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Button actions
    @IBAction func acceptButtonTap(_ sender: UIButton) {
        for VC in self.navigationController!.viewControllers {
            if(VC is ProjectDetailsViewController) {
                let destination = VC as! ProjectDetailsViewController
                destination.firstTime = true
                self.navigationController?.popToViewController(destination, animated: true)
                
                break
            }
        }
    }
    
    
    
}
