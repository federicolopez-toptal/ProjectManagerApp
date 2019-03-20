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
    }
}
