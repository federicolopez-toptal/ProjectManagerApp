//
//  NewProjectViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class NewProjectViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var usersList: UITableView!
    
    var users = [NSDictionary]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentSelection.shared.project.empty()
        
        usersList.tableFooterView = UIView()
        usersList.delegate = self
        usersList.dataSource = self
        usersList.separatorStyle = .none
        
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
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func manageUsersButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoUsers", sender: self)
    }
    
    @IBAction func createProjectButtonTap(_ sender: UIButton) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = users[indexPath.row]["content"] as! NSDictionary
        let name = content["name"] as! String
        
        print(name)
    }
    
}
