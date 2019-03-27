//
//  SurveyUsersViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 26/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class SurveyUsersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var usersList: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var users = [NSDictionary]()
    var selectedUsers = Set<String>()
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersList.tableFooterView = UIView()
        usersList.delegate = self
        usersList.dataSource = self
        
        loading.stopAnimating()
        let nib = UINib.init(nibName: "UserSelectableCell", bundle: nil)
        usersList.register(nib, forCellReuseIdentifier: "UserSelectableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!INTERNET_AVAILABLE()) {
            ALERT(title_ERROR, text_NO_INTERNET, viewController: self)
            return
        }
        
        loading.startAnimating()
        FirebaseManager.shared.getUsers(userIDs: SelectedProject.shared.users) { (usersArray) in
            self.users = usersArray!
            self.usersList.reloadData()
            self.loading.stopAnimating()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSelectableCell", for: indexPath) as! UserSelectableCell
        
        let content = users[indexPath.row]["content"] as! NSDictionary
        let info = content["info"] as! NSDictionary
        let userID = users[indexPath.row]["id"] as! String
        
        var cellText = info["name"] as! String
        if(userID==MyUser.shared.userID) {
            cellText += " (you!)"
        }
        cell.nameLabel.text = cellText
        cell.setState(false)
        cell.setState(selectedUsers.contains(userID))
        
        cell.roleLabel.textColor = UIColor.gray
        if(SelectedProject.shared.hasOfficer(userID: userID)) {
            cell.roleLabel.text = "Project officer"
            cell.roleLabel.textColor = UIColor.red
        } else {
            let email = info["email"] as! String
            if( IS_ATK_MEMBER(email: email) ) {
                cell.roleLabel.text = "ATK member"
            } else {
                cell.roleLabel.text = "Client"
            }
        }
        
        let photoLastUpdate = info["photoLastUpdate"] as? String
        FirebaseManager.shared.userPhoto(userID: userID, lastUpdate: photoLastUpdate, to: cell.photoImageView)
        
        if( SelectedProject.shared.hasOfficer(userID: userID) ) {
            cell.checkImageView.isHidden = true
        } else {
            cell.checkImageView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserSelectableCell
        let userID = users[indexPath.row]["id"] as! String
        
        if( SelectedProject.shared.hasOfficer(userID: userID) ) {
            //
        } else {
            cell.checkImageView.isHidden = false
            cell.setState(!cell.isON)
            if(cell.isON) {
                selectedUsers.insert(userID)
            } else {
                selectedUsers.remove(userID)
            }
        }
        
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButtonTap(_ sender: UIButton) {
        var description = ""
        if let D = SelectedSurvey.shared.description {
            description = D
        }
        
        let info = [
            "projectID": SelectedProject.shared.projectID ,
            "title": SelectedSurvey.shared.title,
            "description": description,
            "created": NOW(),
            "expires": NOW()
        ]
        
        var questions = [String: Any]()
        for (index, Q) in SelectedSurvey.shared.questions.enumerated() {
            
            let questionDict = [
                "text": Q.text,
                "type": Q.type.rawValue,
                "options": createDictFrom(Q.options)
            ] as [String: Any]
            
            questions[String(index)] = questionDict
        }
        
        showLoading(true)
        FirebaseManager.shared.createSurvey(info: info, questions: questions, users: selectedUsers) { (error) in
            if(error != nil) {
                ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
            } else {
                ALERT(title_SUCCES, text_SURVEY_CREATED, viewController: self){
                    var destination: UIViewController?
                    
                    for VC in self.navigationController!.viewControllers {
                        if(VC is ProjectDetailsViewController) {
                            destination = VC
                            break
                        }
                    }
                    
                    if let VC = destination {
                        (VC as! ProjectDetailsViewController).firstTime = true
                        self.navigationController?.popToViewController(VC, animated: true)
                    }
                }
            }
            
            self.showLoading(false)
        }
    }
    
    func createDictFrom(_ array: [String]) -> [String: String] {
        var result = [String: String]()
        for (index, value) in array.enumerated() {
            result[String(index)]=value
        }
        
        return result
    }
    
}
