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

func INTERNET_AVAILABLE() -> Bool {
    let reachability = Reachability()!
    return (reachability.connection != .none)
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

func ALERT(_ title: String, _ text: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    viewController.present(alert, animated: true)
}

func ERROR_CODE(_ error: Error?) -> Int {
    var result = 0
    if let E = error as NSError? {
        result = E.code
        print(">>> ERROR", E.code, E.description)
    }
    
    return result
}
