//
//  UIButtonExtension.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 20/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

extension UIButton {
    func setCircular() {
        self.imageView?.layer.cornerRadius = self.frame.width/2
        self.imageView?.layer.borderWidth = 1.5
        self.imageView?.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.075).cgColor
    }
    
    func setCircularWithRadius(_ radius: CGFloat) {
        self.imageView?.layer.cornerRadius = radius
        self.imageView?.layer.borderWidth = 1.5
        self.imageView?.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.075).cgColor
    }
}
