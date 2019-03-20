//
//  UserSelectableCell.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class UserSelectableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var isON = false
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.setCircular()
        self.selectionStyle = .none
    }
    
    // MARK: - misc
    func setState(_ state: Bool) {
        if(state) {
            checkImageView.image = UIImage(named: "checkON.png")
        } else {
            checkImageView.image = UIImage(named: "checkOFF.png")
        }
        isON = state
    }
    
}
