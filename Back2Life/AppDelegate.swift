//
//  AppDelegate.swift
//  Back2Life
//
//  Created by Bright on 17/05/21.
//

import UIKit
import IQKeyboardManagerSwift
import Stripe
import GooglePlaces
import GoogleMaps
import FirebaseMessaging
import Firebase
import Braintree
import FirebaseCrashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.registerForPushNotifications()
        StripeAPI.defaultPublishableKey = ApiConstants.ProductionServer.stripeKey
        GMSPlacesClient.provideAPIKey(ApiConstants.ProductionServer.googleAPIKey)
        GMSServices.provideAPIKey(ApiConstants.ProductionServer.googleAPIKey)
    //    Thread.sleep(forTimeInterval: 3.0)
        notificationsHandler.configure()
        Router.default.setupAppNavigation(appNavigation: AppNavigation())
        IQKeyboardManager.shared.enable = true
        setRootController()
        return true
    }
    
    func setRootController(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        } else {}
        if let window = self.window{
            //            let viewController = Storyboard.Splash.instantiateViewController(withIdentifier: "SplashNav")
            if UserStoreSingleton.shared.isLoggedIn == nil{
                let viewController = BaseNavigationViewController(rootViewController: Storyboard.Splash.viewController(for: TutorialViewController.self))
           //     SideMenu.shared.setupSideMneu()
                viewController.view.layoutIfNeeded()
                window.rootViewController = viewController
            }else{
                
//                if let isAccepted = UserDefaults.standard.value(forKey: "bookingAccepted") as? Bool {
//                    if isAccepted {
//                        let viewController = BaseNavigationViewController(rootViewController: Storyboard.Booking.viewController(for: ViewQRViewController.self))
//                        SideMenu.shared.setupSideMneu()
//                        viewController.view.layoutIfNeeded()
//                        window.rootViewController = viewController
//                        return
//                    }
//                }
                
                let viewController = BaseNavigationViewController(rootViewController: Storyboard.Home.viewController(for: HomeViewController.self))
                SideMenu.shared.setupSideMneu()
                viewController.view.layoutIfNeeded()
                window.rootViewController = viewController
            }
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            }, completion: nil)
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    //Do stuff
                    let messageResp = message
                    print(messageResp)
                }
            } else if let alert = aps["alert"] as? NSString {
                //Do stuff
                let Resp = alert
                print(Resp)
            }
        }
        
        completionHandler(UNNotificationPresentationOptions.alert)
        // Change this to your preferred presentation option
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let apsdata = userInfo[AnyHashable("aps")] as? NSDictionary
        print(apsdata as Any)
        let notification_data = userInfo[AnyHashable("data")] as! NSDictionary
        print(notification_data as Any)
        GlobalVariable.notification_dict = notification_data as! NSDictionary
        print(GlobalVariable.notification_dict)
        UserDefaults.standard.set(GlobalVariable.notification_dict, forKey: "notification_dict")
        
        UserDefaults.standard.set(notification_data.value(forKey: "type") as! String, forKey: "notification_type")
        print(UserDefaults.standard.value(forKey: "notification_type") as! String)
        if GlobalVariable.notification_dict.value(forKey: "notification_type") as! String == "cancel-booking" {
            if let delegate = UIApplication.shared.delegate as? AppDelegate{
                delegate.setRootController()
                return
            }
        }
        UserDefaults.standard.set(false, forKey: "bookingAccepted")
        if GlobalVariable.notification_dict.value(forKey: "notification_type") as! String == "accept-booking" {
            //UserDefaults.standard.set(true, forKey: "bookingAccepted")
        }
        
        //moveToNextViewController()
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "notificationData"), object: nil, userInfo: notification_data as? [AnyHashable : Any])
    }
    
    func moveToNextViewController() {
        
        let viewController = BaseNavigationViewController(rootViewController: Storyboard.Home.viewController(for: HomeViewController.self))
        SideMenu.shared.setupSideMneu()
        viewController.view.layoutIfNeeded()
        self.window?.rootViewController = viewController
        
//        let viewController = BaseNavigationViewController(rootViewController: Storyboard.Booking.viewController(for: ViewQRViewController.self))
//        SideMenu.shared.setupSideMneu()
//        viewController.view.layoutIfNeeded()
//        self.window?.rootViewController = viewController
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        let apsdata = userInfo[AnyHashable("aps")] as? NSDictionary
        print(apsdata as Any)
        GlobalVariable.notification_dict = userInfo as NSDictionary
        print(GlobalVariable.notification_dict)
        UserDefaults.standard.set(GlobalVariable.notification_dict, forKey: "notification_dict")
        
        //var reportStatus = ""
        
        if GlobalVariable.notification_dict.value(forKey: "notification_type") as! String == "accept-booking" {
            //UserDefaults.standard.set(true, forKey: "bookingAccepted")
        }
        
        if GlobalVariable.notification_dict.value(forKey: "notification_type") as! String == "booking-verify" {
            //UserDefaults.standard.set(false, forKey: "bookingAccepted")
        }
        
        
        //moveToNextViewController()
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "notificationData"), object: nil, userInfo: userInfo as? [AnyHashable : Any])
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // create CLLocation from the coordinates of CLVisit
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        
    }
    
    func newVisitReceived(_ visit: CLVisit, description: String) {
        //let location = Location(visit: visit, descriptionString: description)
        
        // Save location to disk
    }
}

