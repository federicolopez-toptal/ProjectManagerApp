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
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var whiteView: UIView!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        whiteView.layer.shadowColor = UIColor.black.cgColor
        whiteView.layer.shadowOpacity = 0.05
        whiteView.layer.shadowOffset = CGSize(width: 2, height: 2)
        whiteView.layer.shadowRadius = 2.0
    }
    
    
    /*
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // Glow effect
        whiteView.layer.masksToBounds = false
        whiteView.layer.shadowOffset = .zero
        whiteView.layer.shadowColor = UIColor.green.cgColor
        whiteView.layer.shadowRadius = 3
        whiteView.layer.shadowOpacity = 0.5
        whiteView.layer.shadowPath = UIBezierPath(rect: whiteView.bounds).cgPath
    }
    */
    
}
