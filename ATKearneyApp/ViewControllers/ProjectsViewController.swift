//
//  ProjectsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class ProjectsViewController: BaseViewController {

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var createProjectButton: UIButton!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataView.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test()
    }
    
    func test() {
        /*
        // Create user
        let email = "carlos.lopez@toptal.com"
        let pass = "gato123"
        let fields = [
            "admin": false,
            "name": "Federico",
            "phone": "123",
            "email": email
            ] as [String : Any]
        
        FirebaseManager.shared.createUser(email: email, password: pass, values: fields) { (error) in
            if(error != nil) {
                print(CurrentUser.shared)
                print(CurrentUser.shared.userID, CurrentUser.shared.admin)
            }
        }
 */
 
        /*
        // Login
        let email = "carlos.lopez@toptal.com"
        let pass = "gato123"
        FirebaseManager.shared.login(email: email, password: pass) { (user, error) in
            print(CurrentUser.shared.userID, CurrentUser.shared.admin)
        }
 */
    }

}
