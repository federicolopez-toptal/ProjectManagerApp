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
    }
}
