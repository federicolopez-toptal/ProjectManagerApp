//
//  Functions.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 19/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import Foundation
import UIKit


func SUBTRACT(from: [String: String], subtracting: [String: String]) -> [String: String] {
    var result = [String: String]()
    
    for (key, value) in from {
        if( subtracting[key] == nil ) {
            result[key] = value
        }
    }
    
    return result
}


// Date example: 2019-03-19 11:30 -0300
func NOW() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm ZZZ"
    let result = dateFormatter.string(from: Date())
    
    return result
}

func DATE(_ str: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm ZZZ"
    let result = dateFormatter.date(from: str)
    
    return result
}
