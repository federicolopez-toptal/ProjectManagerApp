//
//  ProjectDetailsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 14/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var usersList: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    var users = [NSDictionary]()
    var firstTime = true
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersList.tableFooterView = UIView()
        usersList.delegate = self
        usersList.dataSource = self
        usersList.separatorStyle = .none
        
        let nib = UINib.init(nibName: "UserCell", bundle: nil)
        usersList.register(nib, forCellReuseIdentifier: "UserCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameLabel.text! = SelectedProject.shared.name
        descriptionLabel.text! = SelectedProject.shared.description
        
        if(MyUser.shared.admin || SelectedProject.shared.officers.contains(MyUser.shared.userID)) {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
        
        if(firstTime) {
            FirebaseManager.shared.getUsers(userIDs: SelectedProject.shared.users) { (usersArray) in
                self.users = usersArray!
                self.usersList.reloadData()
            }
            
            firstTime = false
        }
    }

    // MARK: - Button actions
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoEdit", sender: self)
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
        
        if(SelectedProject.shared.officers.contains(userID)) {
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
        SelectedUser.shared.empty()
        
        let userID = users[indexPath.row]["id"] as! String
        SelectedUser.shared.userID = userID
        
        let content = users[indexPath.row]["content"] as! NSDictionary
        let info = content["info"] as! NSDictionary
        
        SelectedUser.shared.name = info["name"] as! String
        SelectedUser.shared.email = info["email"] as! String
        SelectedUser.shared.phone = info["phone"] as! String
        
        self.performSegue(withIdentifier: "gotoUser", sender: self)
    }
    
    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="gotoEdit") {
            let destinationVC = segue.destination as! NewProjectViewController
            destinationVC.editingProject = true
        }
    }
}
