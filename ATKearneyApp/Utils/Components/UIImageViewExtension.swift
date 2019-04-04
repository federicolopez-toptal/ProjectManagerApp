//
//  UIImageViewExtension.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 20/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

extension UIImageView {
    func setCircular() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        self.layer.borderWidth = 1.5
        
        let alpha: CGFloat = 0.06
        let borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
        self.layer.borderColor = borderColor.cgColor
    }
}
