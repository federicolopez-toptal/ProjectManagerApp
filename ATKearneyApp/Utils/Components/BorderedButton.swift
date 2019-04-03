//
//  BorderedButton.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 03/04/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = COLOR_FROM_HEX("#DBD8D8").cgColor
        self.layer.borderWidth = 1.0
    }
    
}
