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
    
    var usersCopy = Set<String>()
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
            nameTextField.text! = CurrentSelection.shared.project.name
            descriptionTextView.text! = CurrentSelection.shared.project.description
            
            usersCopy = CurrentSelection.shared.project.users
        } else {
            CurrentSelection.shared.project.empty()
        }
        
        let nib = UINib.init(nibName: "UserCell", bundle: nil)
        usersList.register(nib, forCellReuseIdentifier: "UserCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseManager.shared.getUsers(userIDs:CurrentSelection.shared.project.users){ (usersArray) in
            self.users = usersArray!
            self.usersList.reloadData()
        }
    }
    
    // MARK: - misc
    func createProject() {
        if(!nameTextField.text!.isEmpty && !descriptionTextView.text.isEmpty && users.count>0) {
            var pUsers = [String: Bool]()
            for userID in CurrentSelection.shared.project.users {
                pUsers[userID] = true
            }
            
            let values = [
                "name": nameTextField.text! as String,
                "description": descriptionTextView.text! as String,
                "users": pUsers
                ] as [String : Any]
            
            FirebaseManager.shared.createProject(values: values){ (error) in
                if(error == nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func editProject() {
        let usersRemoved = usersCopy.subtracting(CurrentSelection.shared.project.users)
        
        if(!nameTextField.text!.isEmpty && !descriptionTextView.text.isEmpty && users.count>0) {
            let projectID = CurrentSelection.shared.project.projectID
            
            var pUsers = [String: Bool]()
            for userID in CurrentSelection.shared.project.users {
                pUsers[userID] = true
            }
            
            let values = [
                "name": nameTextField.text! as String,
                "description": descriptionTextView.text! as String,
                "users": pUsers
                ] as [String : Any]
            
            let usersAdded = CurrentSelection.shared.project.users
            FirebaseManager.shared.editProject(projectID: projectID, values: values, usersAdded: usersAdded, usersRemoved: usersRemoved) { (error) in
                if(error==nil) {
                    CurrentSelection.shared.project.name = self.nameTextField.text!
                    CurrentSelection.shared.project.description = self.descriptionTextView.text!
                    
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
        
        let userID = users[indexPath.row]["id"] as! String
        var cellText = content["name"] as! String
        if(userID==CurrentUser.shared.userID) {
            cellText += " (you!)"
        }
        cell.nameLabel.text = cellText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CurrentSelection.shared.user.empty()
        
        let userID = users[indexPath.row]["id"] as! String
        CurrentSelection.shared.user.userID = userID
        
        let content = users[indexPath.row]["content"] as! NSDictionary
        CurrentSelection.shared.user.name = content["name"] as! String
        CurrentSelection.shared.user.email = content["email"] as! String
        CurrentSelection.shared.user.phone = content["phone"] as! String
        
        self.performSegue(withIdentifier: "gotoShowUser", sender: self)
    }
    
    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="gotoShowUser") {
            let destinationVC = segue.destination as! UserInProjectViewController
            destinationVC.editingUser = true
        }
    }
    
}
