//
//  BaseViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Interaction with UITextfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
