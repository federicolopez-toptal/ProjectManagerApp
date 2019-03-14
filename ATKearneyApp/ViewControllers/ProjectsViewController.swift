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
    
    var projects = [NSDictionary]()
    var selectedProject: NSDictionary?
    
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
        
        createProjectButton.isHidden = !CurrentUser.shared.admin
        createProjectCircleButton.isHidden = !CurrentUser.shared.admin
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseManager.shared.getUserProjects(userID: CurrentUser.shared.userID) { (projects, error) in
            if(error==nil) {
                self.projects = projects!
                self.reload()
            }
        }
    }
    
    // MARK: - Button actions
    @IBAction func createProjectButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoNewProject", sender: self)
    }
    
    // MARK: - misc
    func reload() {
        if(projects.count==0) {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
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
        let users = content["users"] as! [String: Bool]
        let usersCount = users.keys.count
        
        cell.nameLabel.text! = content["name"] as! String
        cell.descriptionLabel.text! = content["description"] as! String
        cell.membersLabel.text = "\(usersCount) MEMBERS"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = projects[indexPath.row]
        self.performSegue(withIdentifier: "gotoDetails", sender: self)
    }
    
    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProjectDetailsViewController
        destinationVC.projectDict = selectedProject
    }

}
