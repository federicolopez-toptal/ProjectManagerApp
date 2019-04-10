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
    return STR_DATE(Date())
}

func STR_DATE(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm_ZZZ"
    let result = dateFormatter.string(from: date)
    
    return result
}

func DATE(_ str: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm_ZZZ"
    let result = dateFormatter.date(from: str)
    
    return result!
}

func STR_DATE_NICE(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    let result = dateFormatter.string(from: date)
    
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

func CHANGE_LABEL_HEIGHT(label: UILabel, text: String) {
    let tmpLabel = UILabel(frame: CGRect(x: 0, y: 0, width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
    tmpLabel.numberOfLines = 0
    tmpLabel.lineBreakMode = .byWordWrapping
    tmpLabel.font = label.font
    tmpLabel.text = text
    tmpLabel.sizeToFit()
    
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    var mFrame = label.frame
    mFrame.size.height = tmpLabel.frame.size.height
    label.frame = mFrame
    
    label.text = text
}

func CHANGE_LABEL_HEIGHT(label: UILabel, text: String, placeBelow: UIView, margin: CGFloat) {
    CHANGE_LABEL_HEIGHT(label: label, text: text)
    PLACE(label, below: placeBelow, margin: margin)
}

func PLACE(_ view: UIView, below: UIView, margin: CGFloat) {
    var mFrame = view.frame
    mFrame.origin.y = BOTTOM(view: below) + margin
    view.frame = mFrame
}

func BOTTOM(view: UIView) -> CGFloat {
    return (view.frame.origin.y + view.frame.size.height)
}

func CHANGE_HEIGHT(view: UIView, _ newHeight: CGFloat) {
    var mFrame = view.frame
    mFrame.size.height = newHeight
    view.frame = mFrame
}

func COLOR_FROM_HEX(_ hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func CALL_URL(_ url: String) {
    
    let task = URLSession.shared.dataTask(with: URL(string: url)!){ (data, response, error) in
        if(error==nil) {
            if let D = data {
                print( String(data: D, encoding: .utf8)! )
            }
        }
    }
    task.resume()
}

func URL_ENCODE(_ text: String) -> String {
    return text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
}

func SHOW_USER_TYPE_IN(label: UILabel, admin: Bool, pOfficer: Bool, email: String) {
    if(admin) {
        label.text = "ADMIN"
        label.textColor = COLOR_FROM_HEX("#BC1832")
    } else if(pOfficer) {
        label.text = "PROJECT OFFICER"
        label.textColor = COLOR_FROM_HEX("#BC1832")
    } else {
        if( IS_ATK_MEMBER(email: email) ) {
            label.text = "ATK MEMBER"
            label.textColor = COLOR_FROM_HEX("#842D2D")
        } else {
            label.text = "CLIENT"
            label.textColor = COLOR_FROM_HEX("#919191")
        }
    }
}





