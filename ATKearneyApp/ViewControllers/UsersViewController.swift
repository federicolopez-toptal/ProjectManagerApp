//
//  UsersViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit


struct basicUser {
    var userID = ""
    var name = ""
}

class UsersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var usersList: UITableView!
    @IBOutlet weak var filterTextField: UITextField!
    
    var users = [basicUser]()
    var filteredUsers = [basicUser]()
    var userIDs = Set<String>()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDs = CurrentSelection.shared.project.users
        
        usersList.tableFooterView = UIView()
        usersList.delegate = self
        usersList.dataSource = self
        
        let nib = UINib.init(nibName: "UserSelectableCell", bundle: nil)
        usersList.register(nib, forCellReuseIdentifier: "UserSelectableCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseManager.shared.getAllUsers { (usersDict, error) in
            if(error != nil) {
                //ADD alert error loading
            } else {
                self.fillDataProvider(source: usersDict)
            }
        }
    }
    
    func fillDataProvider(source: NSDictionary?) {
        for(key, value) in source! {
            let strKey = key as! String
            let dict = value as! NSDictionary
            let name = dict["name"] as! String
            
            users.append( basicUser(userID: strKey, name: name) )
        }
        // Users sorted by name!
        users = users.sorted { (obj1: basicUser, obj2: basicUser) -> Bool in
            return obj1.name < obj2.name
        }
        
        filterUsersWith("")
    }

    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSelectableCell", for: indexPath) as! UserSelectableCell
        
        let user = filteredUsers[indexPath.row]
        var cellText = user.name
        if(user.userID==CurrentUser.shared.userID) {
            cellText += " (you!)"
        }
        
        cell.nameLabel.text = cellText
        cell.setState( userIDs.contains(user.userID) )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserSelectableCell
        cell.setState(!cell.isON)
        
        let user = filteredUsers[indexPath.row]
        if(cell.isON) {
            userIDs.insert(user.userID)
        } else {
            userIDs.remove(user.userID)
        }
    }
    
    // UITextField
    @IBAction func filterTextChange(_ sender: UITextField) {
        let text = sender.text!.lowercased()
        filterUsersWith(text)
    }
    
    func filterUsersWith(_ text: String) {
        if(text.isEmpty) {
            filteredUsers = users
        } else {
            filteredUsers.removeAll()
            for U in users {
                if(U.name.lowercased().contains(text)) {
                    filteredUsers.append(U)
                }
            }
        }
        
        usersList.reloadData()
    }
    
    // MARK: - Button actions
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        CurrentSelection.shared.project.users = userIDs
        self.navigationController?.popViewController(animated: true)
    }
    
}
