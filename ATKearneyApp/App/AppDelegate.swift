//
//  AppDelegate.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

    // MARK: - Init
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        askForPushNotification()
        
        if(launchOptions != nil) {
            // Open the app from push notification
            if let userInfo = launchOptions![.remoteNotification] as? [AnyHashable: Any] {
                let action = userInfo["gcm.notification.action"] as! String
                
                if(action=="showSurvey") {
                    let projectID = userInfo["gcm.notification.projectID"] as! String
                    Navigation.shared.navigate(action: action, params: [projectID])
                }
            }
        }
        
        return true
    }
    
    // MARK: - Push Notifications
    func askForPushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if(granted && error==nil) {
                print("Permissions granted")
            } else {
                if let E = error {
                    print(E.localizedDescription)
                }
            }
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Device.shared.FCMToken = fcmToken
        FirebaseManager.shared.saveDeviceToCurrentUser(deviceToken: fcmToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        let appState = application.applicationState
        
        if(appState == .inactive || appState == .background) {
            let action = userInfo["gcm.notification.action"] as! String
            
            if(action=="showSurvey") {
                let projectID = userInfo["gcm.notification.projectID"] as! String
                Navigation.shared.navigate(action: action, params: [projectID])
            }
        }
    }
    
    
    // MARK: - Custom URL scheme
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /*
         example:
            atkearneyPMO://showSurvey?projectID=123
        */

        if let host = url.host {
            // Open a specific survey
            if(host=="showSurvey") {
                var projectID = ""
                
                let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                if let params = urlComponents?.queryItems {
                    for P in params {
                        if(P.name == "projectID") {
                            projectID = P.value!
                        }
                    }
                }
                
                Navigation.shared.navigate(action: host, params: [projectID])
            }
            
        }
        
        return true
    }
   
}




