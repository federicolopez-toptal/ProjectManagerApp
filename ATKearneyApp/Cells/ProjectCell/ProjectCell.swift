//
//  ProjectCell.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 14/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var whiteView: UIView!
    
    private let BASE_TAG = 444
    private let LIMIT = 5
    
    var usersCount = 0
    var users = [String: String]()
    var usersContainer = UIView()
    
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        let alpha: CGFloat = 0.06
        let borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
        whiteView.layer.borderColor = borderColor.cgColor
        whiteView.layer.borderWidth = 1.0
        
        usersContainer.frame = CGRect(x: 0, y: 110, width: whiteView.frame.width, height: 24.0)
        usersContainer.backgroundColor = UIColor.white
        whiteView.addSubview(usersContainer)
    }
    
    func createUserPictures(users: [String: String]) {
        usersContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        self.users = users
        let count = users.keys.count
        var val_X: CGFloat = 21.0
        
        for i in 0...count-1 {
            let imageView = UIImageView(frame: CGRect(x: val_X, y: 0, width: 24, height: 24))
            imageView.tag = BASE_TAG + i
            imageView.image = nil
            imageView.backgroundColor = COLOR_FROM_HEX("#F5F5F5")
            imageView.setCircular()
            usersContainer.addSubview(imageView)
            
            val_X += 24 * 0.75
            
            if(i+1 == LIMIT) {
                break
            }
        }
        
        val_X += 18.5
        let label = UILabel(frame: CGRect(x: val_X, y: 5, width: whiteView.frame.width-val_X, height: 1))
        label.font = UIFont(name: "Graphik-Regular", size: 14)
        CHANGE_LABEL_HEIGHT(label: label, text: "\(count) Project members")
        usersContainer.addSubview(label)
        
        self.perform(#selector(loadUserPictures), with: nil, afterDelay: 0.5)
    }
    
    @objc func loadUserPictures() {
        FirebaseManager.shared.getUsers(userIDs: users) { (usersArray) in
            
            if let usersProvider = usersArray {
                for (i, U) in usersProvider.enumerated() {
                    let userID = U["id"] as! String
                    
                    let content = U["content"] as! NSDictionary
                    let info = content["info"] as! NSDictionary
                    let photoLastUpdate = info["photoLastUpdate"] as? String
                    
                    let imageView = self.usersContainer.viewWithTag(self.BASE_TAG + i) as! UIImageView
                    FirebaseManager.shared.userPhoto(userID: userID, lastUpdate: photoLastUpdate, to: imageView)
                    
                    if(i+1 == self.LIMIT) {
                        break
                    }
                }
            }
            
        }
    }
    
    
    
}
