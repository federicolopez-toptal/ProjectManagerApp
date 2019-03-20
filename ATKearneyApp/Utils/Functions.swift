//
//  Functions.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 19/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


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


// Date example: 2019-03-19_11-30_-0300
func NOW() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm_ZZZ"
    let result = dateFormatter.string(from: Date())
    
    return result
}

func DATE(_ str: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm_ZZZ"
    let result = dateFormatter.date(from: str)
    
    return result
}

func ALERT(_ title: String, _ text: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    viewController.present(alert, animated: true)
}

func ALERT(_ title: String, _ text: String, viewController: UIViewController, callback: @escaping () -> ()) {
    let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (alertAction) in
        print(alertAction)
        callback()
    }
    
    alert.addAction(okAction)
    viewController.present(alert, animated: true) {
        callback()
    }
}

func ERROR_CODE(_ error: Error?) -> Int {
    var result = 0
    if let E = error as NSError? {
        result = E.code
        print(">>> ERROR", E.code, E.description)
    }
    
    return result
}

func IS_ATK_MEMBER(email: String) -> Bool {
    return email.contains("@atkearney.com")
}

func PERMISSIONS_FOR_CAMERA() -> Bool {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    
    if(authStatus == .denied) {
        return false
    } else {
        // .authorized
        // .restricted
        // .notDetermined
        return true
    }
}

func DOCS_PATH() -> String {
    let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    return docsPath!.absoluteString.replacingOccurrences(of: "file://", with: "")
}

func FILE_IN_DOCS(filename: String) -> String {
    return "\(DOCS_PATH())\(filename)"
}

func MBs(_ amount: CGFloat) -> Int64 {
    let result = amount * 1024 * 1024
    return Int64(result)
}

func DELAY(time: Double, callback: @escaping () -> () ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        callback()
    }
}
