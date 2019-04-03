//
//  Navigation.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 02/04/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class Navigation {
    static var shared = Navigation()
    
    var sarasa: Any?
    
    var action = ""
    var active = false
    var navController: UINavigationController?
    
    private var currentParam = 0
    private var params = [String]()
    
    func navigate(action: String, params: [String]) {
        self.action = action
        active = true
        currentParam = 0
        self.params = params
        
        if(navController==nil) {
            return
        } else {
            if(action=="showSurvey"){
                let lastVC = navController!.viewControllers.last
                if(lastVC is ProjectsViewController) {
                    (lastVC as! ProjectsViewController).navigate()
                } else {
                    for VC in navController!.viewControllers {
                        if(VC is ProjectsViewController) {
                            navController!.popToViewController(VC, animated: true)
                            break
                        }
                    }
                }
            }

        }
        
    }
    
    func getParam() -> String {
        if(params.isEmpty) {
            return ""
        }
        
        return params[currentParam]
    }
    
    func next() {
        currentParam += 1
        if(currentParam==params.count) {
            active = false
        }
    }
    
    func finish() {
        active = false
    }
}
