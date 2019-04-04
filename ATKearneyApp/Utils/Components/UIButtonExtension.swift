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
        
        let alpha: CGFloat = 0.06
        let borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
        self.imageView?.layer.borderColor = borderColor.cgColor
    }
    
    func setCircularWithRadius(_ radius: CGFloat) {
        self.imageView?.layer.cornerRadius = radius
        self.imageView?.layer.borderWidth = 1.5
        
        let alpha: CGFloat = 0.06
        let borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
        self.imageView?.layer.borderColor = borderColor.cgColor
    }
}
