//
//  ProjectsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class ProjectsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var createProjectButton: UIButton!
    @IBOutlet weak var createProjectCircleButton: UIButton!
    @IBOutlet weak var projectsList: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var projects = [NSDictionary]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataView.backgroundColor = UIColor.white
        noDataView.isHidden = true
        
        projectsList.tableFooterView = UIView()
        projectsList.delegate = self
        projectsList.dataSource = self
        projectsList.separatorStyle = .none
        
        let nib = UINib.init(nibName: "ProjectCell", bundle: nil)
        projectsList.register(nib, forCellReuseIdentifier: "ProjectCell")
        
        createProjectButton.isHidden = !MyUser.shared.admin
        createProjectCircleButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(MyUser.shared.admin){
            titleLabel.text! = "All projects"
            FirebaseManager.shared.getAllProjects { (projects, error) in
                if(error==nil) {
                    self.projects = projects!
                    self.reload()
                }
            }
        } else {
            titleLabel.text! = "My projects"
            FirebaseManager.shared.getUserProjects(userID: MyUser.shared.userID) { (projects, error) in
                if(error==nil) {
                    self.projects = projects!
                    self.reload()
                }
            }
        }
    }
    
    // MARK: - Button actions
    @IBAction func createProjectButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoNewProject", sender: self)
    }
    
    @IBAction func profileButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoUser", sender: self)
    }
    
    // MARK: - misc
    func reload() {
        if(projects.count==0) {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
            createProjectCircleButton.isHidden = !MyUser.shared.admin
        }
        
        projectsList.reloadData()
    }
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        let project = projects[indexPath.row]
        let content = project["content"] as! [String: Any]
        let info = content["info"] as! [String: String]
        let users = content["users"] as! [String: Bool]
        let usersCount = users.keys.count
        
        cell.nameLabel.text! = info["name"]! as String
        cell.descriptionLabel.text! = info["description"]! as String
        cell.membersLabel.text = "\(usersCount) MEMBERS"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedProject.shared.empty()
        
        let projectDict = projects[indexPath.row]
        SelectedProject.shared.projectID = projectDict["id"] as! String
        
        let content = projectDict["content"] as! [String: Any]
        let info = content["info"] as! [String: String]
        SelectedProject.shared.name = info["name"]! as String
        SelectedProject.shared.description = info["description"]! as String
        
        let users = content["users"] as! [String: Bool]
        for (keyUserID, _) in users {
            SelectedProject.shared.users.insert(keyUserID)
        }
        
        if let officers = content["officers"] as? [String: Bool] {
            for (keyUserID, _) in officers {
                SelectedProject.shared.officers.insert(keyUserID)
            }
        }
        
        self.performSegue(withIdentifier: "gotoDetails", sender: self)
    }

}
