//
//  ProjectsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class ProjectsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var createProjectButton: UIButton!
    @IBOutlet weak var createProjectCircleButton: UIButton!
    //@IBOutlet weak var createProjectCircleButton: UIButton!
    @IBOutlet weak var projectsList: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var bottomWhiteViewHeightContraint: NSLayoutConstraint!
    
    var projects = [NSDictionary]()
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataView.backgroundColor = self.view.backgroundColor
        projectsList.backgroundColor = self.view.backgroundColor
        noDataView.isHidden = true
        
        projectsList.tableFooterView = UIView()
        projectsList.delegate = self
        projectsList.dataSource = self
        projectsList.separatorStyle = .none
        
        let nib = UINib.init(nibName: "ProjectCell", bundle: nil)
        projectsList.register(nib, forCellReuseIdentifier: "ProjectCell")
        
        if(!MyUser.shared.admin) {
            bottomWhiteViewHeightContraint.constant = 0.0
            noDataLabel.text = "There is no projects available for\nyou at the moment. Get in touch\nwith your project officer to add your project"
        }
        createProjectButton.isHidden = !MyUser.shared.admin
        createProjectCircleButton.isHidden = true
        loading.stopAnimating()
        
        photoButton.setCircular()
        addReloadView(frame: projectsList.frame) {
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        FirebaseManager.shared.userPhoto(userID: MyUser.shared.userID, lastUpdate: MyUser.shared.photoLastUpdate, to: photoButton)
        
        MyUser.shared.traceAll()
    }
    
    // MARK: - navigation
    func navigate() {
        if(Navigation.shared.active && Navigation.shared.action=="showSurvey") {
            let projectID = Navigation.shared.getParam()
            
            var found = false
            for (index, P) in projects.enumerated() {
                let pID = P["id"] as! String
                if(pID==projectID) {
                    found = true
                    Navigation.shared.finish()
                    tableView(projectsList, didSelectRowAt: IndexPath(row: index, section: 0))
                    break
                }
            }
            
            if(!found) {
                Navigation.shared.finish()
                ALERT(title_ERROR, text_PROJECT_NOT_FOUND, viewController: self)
            }
        }
    }
    
    // MARK: - Button actions
    @IBAction func createProjectButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoNewProject", sender: self)
    }
    
    @IBAction func profileButtonTap(_ sender: UIButton) {
        SelectedUser.shared = MyUser.shared
        self.performSegue(withIdentifier: "gotoUser", sender: self)
    }
    
    // MARK: - Data
    func loadData() {
        loading.startAnimating()
        if(MyUser.shared.admin){
            titleLabel.text! = "All projects"
            FirebaseManager.shared.getAllProjects { (projects, error) in
                if(error==nil) {
                    self.projects = projects!
                    self.reload()
                } else {
                    ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
                    self.showReloadView()
                }
                
                self.loading.stopAnimating()
            }
        } else {
            titleLabel.text! = "My projects"
            FirebaseManager.shared.getUserProjects(userID: MyUser.shared.userID) { (projects, error) in
                if(error==nil) {
                    self.projects = projects!
                    self.reload()
                } else {
                    ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
                    self.showReloadView()
                }
                
                self.loading.stopAnimating()
            }
        }
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
        navigate()
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
        let users = content["users"] as! [String: String]
        let usersCount = users.keys.count
        
        cell.nameLabel.text! = info["name"]! as String
        cell.descriptionLabel.text! = info["description"]! as String
        cell.membersLabel.text = "\(usersCount) Project members"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedProject.shared.reset()
        SelectedProject.shared.fillWith(dict: projects[indexPath.row])
        self.performSegue(withIdentifier: "gotoDetails", sender: self)
    }
    
    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="gotoUser") {
            let destinationVC = segue.destination as! UserDetailsViewController
            destinationVC.canEditMyProfile = true
            destinationVC.profileInProject = false
            destinationVC.officerRoleEditable = false
        }
    }

}
