//
//  AppDelegate + PushNotifications.swift
//  ShakoMako
//
//  Created by Mohini's Mac on 24/11/20.
//  Copyright © 2020 ShakoMako. All rights reserved.
//

import Foundation
import Firebase
import UIKit
//import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import NotificationCenter


extension AppDelegate : MessagingDelegate,UNUserNotificationCenterDelegate{
        
    func registerForPushNotifications() {
          if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                  options: authOptions,
                  completionHandler: {_, _ in })
              // For iOS 10 data message (sent via FCM)
              Messaging.messaging().delegate = self
          } else {
              let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              UIApplication.shared.registerUserNotificationSettings(settings)
          }
          UIApplication.shared.registerForRemoteNotifications()
          updateFirestorePushTokenIfNeeded()
      }

    
    func updateFirestorePushTokenIfNeeded() {
           if let token = Messaging.messaging().fcmToken {
            print("FCM TOKEN IS....",token)
            UserStoreSingleton.shared.fcmToken = token
           }
       }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
           updateFirestorePushTokenIfNeeded()
       }
   
}

extension AppDelegate{
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print(notification.request.content.userInfo)
//        let notificationDict = notification.request.content.userInfo as [AnyHashable:Any]
//        let type = notificationDict["notificationType"] as? String ?? ""
//
//    }
//
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("did receive",response.notification.request.content.userInfo)
//        let notificationDict = response.notification.request.content.userInfo as? [String:Any] ?? [:]
//        let type = notificationDict["notificationType"] as? String ?? ""
//        if type == "chatMessage"{
//
//        }else{
//        }
//        completionHandler()
//    }
 

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        print("didReceiveRemoteNotification",userInfo)
//    }
}



//MARK:- Navigation + Root

extension AppDelegate{
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let navigationController = getNavigationController() {
            return navigationController.visibleViewController
        }
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
    func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    
    func openNotificationScreen(){
        guard let window = self.window  else {
            return
        }
    }
  
}
