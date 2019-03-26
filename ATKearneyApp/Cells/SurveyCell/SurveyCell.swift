//
//  SurveyCell.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 26/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class SurveyCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
