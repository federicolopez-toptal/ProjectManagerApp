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
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var surveyView: UIView!
    @IBOutlet weak var surveyLabel: UILabel!
    @IBOutlet weak var createSurveyButton: UIButton!
    @IBOutlet weak var loadingSurvey: UIActivityIndicatorView!
    @IBOutlet weak var surveysList: UITableView!
    @IBOutlet weak var noSurveysLabel: UILabel!
    
    var surveysFilter = 0
    @IBOutlet weak var surveySelectorView: UIView!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    
    var users = [NSDictionary]()
    var surveys = [NSDictionary]()
    var firstTime = true
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersList.tableFooterView = UIView()
        usersList.delegate = self
        usersList.dataSource = self
        usersList.separatorStyle = .none
        
        surveysList.tableFooterView = UIView()
        surveysList.delegate = self
        surveysList.dataSource = self
        surveysList.separatorStyle = .none
        
        surveyView.backgroundColor = UIColor.white
        loading.stopAnimating()
        loadingSurvey.stopAnimating()
        
        let nib = UINib.init(nibName: "UserCell", bundle: nil)
        usersList.register(nib, forCellReuseIdentifier: "UserCell")
        
        let nib2 = UINib.init(nibName: "SurveyCell", bundle: nil)
        surveysList.register(nib2, forCellReuseIdentifier: "SurveyCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text! = SelectedProject.shared.name
        descriptionLabel.text! = SelectedProject.shared.description
        
        if(MyUser.shared.admin || SelectedProject.shared.hasOfficer(userID: MyUser.shared.userID)) {
            editButton.isHidden = false
            createSurveyButton.isHidden = false
        } else {
            editButton.isHidden = true
            createSurveyButton.isHidden = true
        }
        
        if(!INTERNET_AVAILABLE()) {
            ALERT(title_ERROR, text_NO_INTERNET, viewController: self)
            return
        }
        
        if(firstTime) {
            loading.startAnimating()
            FirebaseManager.shared.getUsers(userIDs: SelectedProject.shared.users) { (usersArray) in
                self.users = usersArray!
                self.usersList.reloadData()
                self.loading.stopAnimating()
            }
            
            // Load surveys
            noSurveysLabel.isHidden = true
            loadingSurvey.startAnimating()
            if(MyUser.shared.admin || SelectedProject.shared.hasOfficer(userID: MyUser.shared.userID)) {
                loadSurveysForAdmin()
                
            } else {
                surveyLabel.text = "Surveys to answer"
                
                heightContraint.constant = 0.0
                surveySelectorView.isHidden = true
                
                // get surveys that includes my user
                surveys = [NSDictionary]()
                FirebaseManager.shared.getSurveysForUser(MyUser.shared.userID) { (surveysArray, error) in
                    
                    //self.surveys = surveysArray!      // Without filters
                    
                    // Filter: Include (NON EXPIRED + ACTIVE) + NON ANSWERED surveys
                    for dict in surveysArray! {
                        if(!self.isExpired(dict: dict) && self.isActive(dict: dict)) {
                            let shouldAnswer = dict["shouldAnswer"] as! Bool
                            if(shouldAnswer) {
                                self.surveys.append(dict)
                            }
                        }
                    }
                    
                    if(self.surveys.count==0) {
                        self.noSurveysLabel.isHidden = false
                        self.noSurveysLabel.text = "No surveys for now..."
                    }
                    self.surveysList.reloadData()
                    self.loadingSurvey.stopAnimating()
                }
            }

            firstTime = false
        }
    }
    
    func loadSurveysForAdmin() {
        noSurveysLabel.isHidden = true
        loadingSurvey.startAnimating()
        
        // UI update
        for (i, V) in surveySelectorView.subviews.enumerated() {
            let button = (V as! UIButton)
            if(i==surveysFilter) {
                button.setTitleColor(UIColor.black, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
            } else {
                button.setTitleColor(UIColor.lightGray, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            }
            
        }
        
        // get all surveys for this project (I'm an admin or project officer)
        surveys = [NSDictionary]()
        FirebaseManager.shared.getSurveysForProject(SelectedProject.shared.projectID) { (surveysArray, error) in
            //self.surveys = surveysArray!      // Without filters
            
            
            for dict in surveysArray! {
                if(self.surveysFilter==0) {     // Filter: Include NON EXPIRED and ACTIVE surveys
                    if(!self.isExpired(dict: dict) && self.isActive(dict: dict)) {
                        self.surveys.append(dict)
                    }
                } else {                        // Filter: Include EXPIRED and INACTIVE surveys
                    if(self.isExpired(dict: dict)) {
                        self.surveys.append(dict)
                    } else if(!self.isActive(dict: dict)) {
                        self.surveys.append(dict)
                    }
                }
            }
            
            if(self.surveys.count==0) {
                self.noSurveysLabel.isHidden = false
                self.noSurveysLabel.text = "No surveys found"
            }
            
            self.surveysList.reloadData()
            self.loadingSurvey.stopAnimating()
        }
    }
    
    func isExpired(dict: NSDictionary) -> Bool {
        let content = dict["content"] as! NSDictionary
        let info = content["info"] as! NSDictionary
        let expires = info["expires"] as! String
        let expDate = DATE(expires)
        
        let isValid = expDate > Date()
        return !isValid
    }
    
    func isActive(dict: NSDictionary) -> Bool {
        let content = dict["content"] as! NSDictionary
        let info = content["info"] as! NSDictionary
        let active = info["active"] as! Bool
        
        return active
    }

    // MARK: - Button actions
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoEdit", sender: self)
    }
    
    @IBAction func createSurveyButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoNewSurvey", sender: self)
    }
    
    @IBAction func surveySelectorButtonTap(_ sender: UIButton) {
        surveysFilter = sender.tag
        
        for V in surveySelectorView.subviews {
            let button = (V as! UIButton)
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        }
    
        sender.setTitleColor(UIColor.black, for: .normal)
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        
        loadSurveysForAdmin()
    }
    
    
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == usersList) {
            return users.count
        } else if (tableView == surveysList) {
            return surveys.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == usersList) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            let content = users[indexPath.row]["content"] as! NSDictionary
            let info = content["info"] as! NSDictionary
        
            let userID = users[indexPath.row]["id"] as! String
            var cellText = info["name"] as! String
            if(userID==MyUser.shared.userID) {
                cellText += " (you!)"
            }
            cell.nameLabel.text = cellText
        
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
        
            return cell
        } else if (tableView == surveysList) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as! SurveyCell
            let content = surveys[indexPath.row]["content"] as! NSDictionary
            let info = content["info"] as! NSDictionary
            
            let title = info["title"] as! String
            cell.titleLabel.text = title
            
            let expDate = DATE(info["expires"] as! String)
            cell.expirationLabel.text = "EXPIRES: \(STR_DATE_NICE(expDate))"
            
            return cell
        }
    
        return tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == usersList) {
            return 50
        } else if (tableView == surveysList) {
            return 55
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == usersList ){
            SelectedUser.shared.reset()
            SelectedUser.shared.fillWith(info: users[indexPath.row])
            self.performSegue(withIdentifier: "gotoUser", sender: self)
        } else if(tableView == surveysList) {
            SelectedSurvey.shared.fillWith(dict: surveys[indexPath.row])
            if(MyUser.shared.admin || SelectedProject.shared.hasOfficer(userID: MyUser.shared.userID)) {
                self.performSegue(withIdentifier: "gotoResults", sender: self)
            } else {
                self.performSegue(withIdentifier: "gotoAnswer", sender: self)
            }
        }
    }
    
    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="gotoEdit") {
            let destinationVC = segue.destination as! NewProjectViewController
            destinationVC.editingProject = true
        } else if(segue.identifier=="gotoUser") {
            let destinationVC = segue.destination as! UserDetailsViewController
            destinationVC.profileInProject = true
            destinationVC.officerRoleEditable = false
            destinationVC.canEditMyProfile = false
        } else if(segue.identifier=="gotoResults") {
            let destinationVC = segue.destination as! SurveyResultsViewController
            if(surveysFilter==0) {
                destinationVC.isActive = true
            } else {
                destinationVC.isActive = false
            }
        }
    }
    
}