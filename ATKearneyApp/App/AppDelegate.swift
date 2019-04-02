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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

    // MARK: - Init
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        askForPushNotification()
        
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
   
}







/*
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 print(deviceToken)
 Messaging.messaging().apnsToken = deviceToken
 }
 
 func application(application: UIApplication,
 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
 Messaging.messaging().apnsToken = deviceToken as Data
 }
 
 func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
 // If you are receiving a notification message while your app is in the background,
 // this callback will not be fired till the user taps on the notification launching the application.
 // TODO: Handle data of notification
 
 // With swizzling disabled you must let Messaging know about the message, for Analytics
 // Messaging.messaging().appDidReceiveMessage(userInfo)
 
 // Print message ID.
 
 if let messageID = userInfo[gcmMessageIDKey] {
 print("Message ID: \(messageID)")
 }
 
 // Print full message.
 print(userInfo)
 }
 
 func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
 // If you are receiving a notification message while your app is in the background,
 // this callback will not be fired till the user taps on the notification launching the application.
 // TODO: Handle data of notification
 
 // With swizzling disabled you must let Messaging know about the message, for Analytics
 // Messaging.messaging().appDidReceiveMessage(userInfo)
 
 // Print message ID.
 
 if let messageID = userInfo[gcmMessageIDKey] {
 print("Message ID: \(messageID)")
 }
 
 
 // Print full message.
 print(userInfo)
 
 completionHandler(UIBackgroundFetchResult.newData)
 }
 
 */
