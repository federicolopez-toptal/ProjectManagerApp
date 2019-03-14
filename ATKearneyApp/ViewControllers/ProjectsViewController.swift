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
    
    var projects = [NSDictionary]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataView.backgroundColor = UIColor.white
        //noDataView.isHidden = true
        
        createProjectButton.isHidden = !CurrentUser.shared.admin
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseManager.shared.getUserProjects(userID: CurrentUser.shared.userID) { (projects, error) in
            if(error==nil) {
                self.projects = projects!
            }
        }
        
        /*
        FirebaseManager.shared.getUsers(userIDs:CurrentSelection.shared.project.users){ (usersArray) in
            self.users = usersArray!
            self.usersList.reloadData()
        }
         */
    }
    
    // MARK: - Button actions
    @IBAction func createProjectButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoNewProject", sender: self)
    }
    
    

}
