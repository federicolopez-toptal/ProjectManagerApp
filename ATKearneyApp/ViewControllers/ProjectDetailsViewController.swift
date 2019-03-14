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
        
        nameLabel.text! = CurrentSelection.shared.project.name
        descriptionLabel.text! = CurrentSelection.shared.project.description
        
        if(firstTime) {
            FirebaseManager.shared.getUsers(userIDs: CurrentSelection.shared.project.users) { (usersArray) in
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
        if(segue.identifier=="gotoEdit") {
            let destinationVC = segue.destination as! NewProjectViewController
            destinationVC.editingProject = true
        }
    }
}
