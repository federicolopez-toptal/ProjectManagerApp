//
//  NewProjectViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class NewProjectViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var usersList: UITableView!
    @IBOutlet weak var actionButton: UIButton!
    
    var usersCopy = [String: String]()
    var users = [NSDictionary]()
    var editingProject = false
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersList.tableFooterView = UIView()
        usersList.delegate = self
        usersList.dataSource = self
        usersList.separatorStyle = .none
        
        if(editingProject) {
            titleLabel.text = "Edit project"
            actionButton.setTitle("Save changes", for: .normal)
            nameTextField.text! = SelectedProject.shared.name
            descriptionTextView.text! = SelectedProject.shared.description
            
            usersCopy = SelectedProject.shared.users
        } else {
            SelectedProject.shared.reset()
        }
        
        let nib = UINib.init(nibName: "UserCell", bundle: nil)
        usersList.register(nib, forCellReuseIdentifier: "UserCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseManager.shared.getUsers(userIDs:SelectedProject.shared.users){ (usersArray) in
            self.users = usersArray!
            self.usersList.reloadData()
        }
    }
    
    // MARK: - misc
    func createProject() {
        if(!nameTextField.text!.isEmpty && !descriptionTextView.text.isEmpty && users.count>0) {
            let info = [
                "name": nameTextField.text! as String,
                "description": descriptionTextView.text! as String
            ]
            
            FirebaseManager.shared.createProject(info: info, users: SelectedProject.shared.users){ (error) in
                if(error == nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func editProject() {
        let usersToRemove = Project.subtract(from: usersCopy, subtracting: SelectedProject.shared.users)
            
        if(!nameTextField.text!.isEmpty && !descriptionTextView.text.isEmpty && users.count>0) {
            let projectID = SelectedProject.shared.projectID
            
            let info = [
                "name": nameTextField.text! as String,
                "description": descriptionTextView.text! as String
            ]
            
            let usersAdded = SelectedProject.shared.users
            FirebaseManager.shared.editProject(projectID: projectID, info: info, users: SelectedProject.shared.users, usersToRemove: usersToRemove) { (success) in

                if(success) {
                    SelectedProject.shared.name = self.nameTextField.text!
                    SelectedProject.shared.description = self.descriptionTextView.text!
                    
                    let lastIndex = (self.navigationController?.viewControllers.count)!-1
                    let prevVC = self.navigationController?.viewControllers[lastIndex-1] as! ProjectDetailsViewController
                    prevVC.firstTime = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func manageUsersButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoUsers", sender: self)
    }
    
    @IBAction func createProjectButtonTap(_ sender: UIButton) {
        if(editingProject) {
            editProject()
        } else {
            createProject()
        }
    }
    
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let content = users[indexPath.row]["content"] as! NSDictionary
        let info = content["info"] as! NSDictionary
        
        let userID = users[indexPath.row]["id"] as! String
        var cellText = info["name"] as! String
        if(userID==MyUser.shared.userID) {
            cellText += " (you!)"
        }
        cell.nameLabel.text = cellText
        
        if(SelectedProject.shared.hasOfficer(userID: userID)) {
            cell.projectOfficerLabel.isHidden = false
        } else {
            cell.projectOfficerLabel.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedUser.shared.reset()
        SelectedUser.shared.fillWith(info: users[indexPath.row])
        
        self.performSegue(withIdentifier: "gotoUser", sender: self)
    }
    
    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="gotoUser") {
            let destinationVC = segue.destination as! UserDetailsViewController
            destinationVC.officerEditable = true
        }
    }
    
}
