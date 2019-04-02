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
    @IBOutlet weak var expirationDateButton: UIButton!
    
    let darkView = UIView()
    let datePicker = UIDatePicker()
    var dateSelected = false
    
    var users = [NSDictionary]()
    var selectedUsers = Set<String>()
    
    var emails = Set<String>()
    var deviceTokens = Set<String>()
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersList.tableFooterView = UIView()
        usersList.delegate = self
        usersList.dataSource = self
        
        loading.stopAnimating()
        let nib = UINib.init(nibName: "UserSelectableCell", bundle: nil)
        usersList.register(nib, forCellReuseIdentifier: "UserSelectableCell")
        
        buildDateSelector()
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
    
    // MARK: - Date Selector
    func buildDateSelector() {
        darkView.frame = self.view.frame
        darkView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(darkViewOnTap(sender:)))
        darkView.addGestureRecognizer(gesture)
        darkView.isHidden = true
        self.view.addSubview(darkView)
        
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216)
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        darkView.addSubview(datePicker)
        datePicker.date = Date()
        datePicker.center = darkView.center
        
        let okButton = UIButton(type: .custom)
        okButton.frame = CGRect(x: self.view.frame.size.width - 105, y: BOTTOM(view: datePicker) + 5.0, width: 100, height: 35)
        okButton.backgroundColor = UIColor.white
        okButton.setTitle("Ok", for: .normal)
        okButton.setTitleColor(UIColor.black, for: .normal)
        okButton.addTarget(self, action: #selector(okDateButtonTap), for: .touchUpInside)
        darkView.addSubview(okButton)
    }
    @objc func darkViewOnTap(sender: UITapGestureRecognizer) {
        darkView.isHidden = true
    }
    @IBAction func expirationButtonTap(_ sender: UIButton) {
        darkView.isHidden = false
    }
    @objc func okDateButtonTap(sender: UIButton) {
        if(datePicker.date <= Date()) {
            ALERT(title_ERROR, text_EXP_DATE_ERROR, viewController: self)
        } else {
            var selectedDate = datePicker.date
            selectedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: selectedDate)!

            SelectedSurvey.shared.expires = selectedDate
            dateSelected = true
            
            expirationDateButton.setTitle(" \(STR_DATE_NICE(selectedDate))", for: .normal)
            darkView.isHidden = true
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
        let content = users[indexPath.row]["content"] as! NSDictionary
        let info = content["info"] as! NSDictionary
        
        if( SelectedProject.shared.hasOfficer(userID: userID) ) {
            //
        } else {
            cell.checkImageView.isHidden = false
            cell.setState(!cell.isON)
            if(cell.isON) {
                selectedUsers.insert(userID)
                
                emails.insert(info["email"] as! String)
                if let deviceToken = info["deviceToken"] as? String {
                    deviceTokens.insert(deviceToken)
                }
            } else {
                selectedUsers.remove(userID)
                
                emails.remove(info["email"] as! String)
                if let deviceToken = info["deviceToken"] as? String {
                    deviceTokens.remove(deviceToken)
                }
            }
        }
        
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectAllButtonTap(_ sender: UIButton) {
        selectedUsers = Set<String>()
        for (index, _) in users.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = usersList.cellForRow(at: indexPath) as! UserSelectableCell
            let userID = users[index]["id"] as! String
            let content = users[indexPath.row]["content"] as! NSDictionary
            let info = content["info"] as! NSDictionary
            
            if( !SelectedProject.shared.hasOfficer(userID: userID) ) {
                // Check all the clients / ATK Members
                cell.setState(true)
                cell.checkImageView.isHidden = false
                selectedUsers.insert(userID)
                
                emails.insert(info["email"] as! String)
                if let deviceToken = info["deviceToken"] as? String {
                    deviceTokens.insert(deviceToken)
                }
            } else {
                cell.setState(false)
                cell.checkImageView.isHidden = true
            }
            
            
        }
    }
    
    
    @IBAction func createButtonTap(_ sender: UIButton) {
        if(!dateSelected) {
            ALERT(title_ERROR, text_EXP_DATE_BLANK, viewController: self)
            return
        }
        if(selectedUsers.isEmpty) {
            ALERT(title_ERROR, text_SURVEY_NO_USERS, viewController: self)
            return
        }
        
        var description = ""
        if let D = SelectedSurvey.shared.description {
            description = D
        }
        
        let info = [
            "projectID": SelectedProject.shared.projectID ,
            "title": SelectedSurvey.shared.title,
            "description": description,
            "active": true,
            "created": NOW(),
            "expires": STR_DATE(SelectedSurvey.shared.expires)
        ] as [String: Any]
        
        var questions = [String: Any]()
        for (index, Q) in SelectedSurvey.shared.questions.enumerated() {
            
            let questionDict = [
                "text": Q.text,
                "type": Q.type.rawValue,
                "options": createDictFrom(Q.options)
            ] as [String: Any]
            
            questions[String(index)] = questionDict
        }
        
        sendNotifications()
        showLoading(false)
        return
        
            
            
            
            
            
        
        showLoading(true)
        FirebaseManager.shared.createSurvey(info: info, questions: questions, users: selectedUsers) { (error) in
            if(error != nil) {
                ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
            } else {
                // Enviar push notifications + emails
                self.sendNotifications()
                
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
    
    func sendNotifications() {
        var strEmails = ""
        for E in emails {
            if(!strEmails.isEmpty) {
                strEmails += ","
            }
            strEmails += E
        }
        
        var strDeviceTokens = ""
        for T in deviceTokens {
            if(!strDeviceTokens.isEmpty) {
                strDeviceTokens += ","
            }
            strDeviceTokens += T
        }
        
        
        
        if(!strEmails.isEmpty) {
            var url = FirebaseManager.FUNC_SEND_EMAIL
            url = url.replacingOccurrences(of: "<TO>", with: strEmails)
            url = url.replacingOccurrences(of: "<TYPE>", with: "addedToSurvey")
            url = url.replacingOccurrences(of: "<PARAM1>", with: SelectedProject.shared.projectID)
            url = url.replacingOccurrences(of: "<PARAM2>", with: URL_ENCODE(SelectedSurvey.shared.title))

            CALL_URL(url)
        }
        
        if(!strDeviceTokens.isEmpty) {
            var url = FirebaseManager.FUNC_SEND_PUSH
            url = url.replacingOccurrences(of: "<TO>", with: strDeviceTokens)
            url = url.replacingOccurrences(of: "<TYPE>", with: "addedToSurvey")
            url = url.replacingOccurrences(of: "<PARAM1>", with: URL_ENCODE(SelectedSurvey.shared.title))
            
            CALL_URL(url)
        }
        
    }
    
}
