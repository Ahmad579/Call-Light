//
//  AppDelegate.swift
//  Call Light
//
//  Created by Ahmed Durrani on 14/04/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import SwiftyUserDefaults


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {
    let available = DefaultsKey<Int>("availability")

    var window: UIWindow?
    var token = UserDefaults.standard
    var nursesID = [Int]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
            application.applicationIconBadgeNumber = 0
        _ =  Location.getLocation(withAccuracy:.block, frequency: .oneShot, onSuccess: { location in
            print("loc \(location.coordinate.longitude)\(location.coordinate.latitude)")
            DEVICE_LAT = location.coordinate.latitude
            DEVICE_LONG = location.coordinate.longitude
        
        }, onError: { (last, error) in
            print("Something bad has occurred \(error)")
        })
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        registerForPushNotifications(application: application)
        
        application.registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        return true
    }

    //for remote notifcations
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (greanted, error) in
                if greanted {
                    
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                        //                        Defaults.set("-1", forKey: "avail")
                    }
                    
                    UIApplication.shared.registerForRemoteNotifications();
                }
            }
        } else {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            //            Defaults.set("-1", forKey: "deviceToken")
            UIApplication.shared.registerForRemoteNotifications();
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("GOT A NOTIFICATION")
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HospitalRequest"), object: nil, userInfo: data)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClientReceiveRequest"), object: nil, userInfo: data)
     
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        application.applicationIconBadgeNumber += 1
        
        let isShift = userInfo[AnyHashable("is_shift_ended")] as? Int
        let isCanel = userInfo[AnyHashable("cancel")] as? Int
        if isCanel == 1 {
            
        } else {
            if isShift == 1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShiftEnd"), object: nil, userInfo: userInfo)
            } else {
                print("helo Printer")
            }
        }
        
//        if userInfo[AnyHashable("is_shift_ended")] !=  0 {
//            print("HEllo")
//        } else {
//            print("HEllo Bro")
//
//        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HospitalRequest"), object: nil, userInfo: userInfo)

//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClientReceiveRequest"), object: nil, userInfo: userInfo)
        print(userInfo)
        
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        let device_token = String(format: "%@", deviceToken as CVarArg) as String
        print(tokenString(deviceToken))
        DEVICE_TOKEN = tokenString(deviceToken)
        print ("device token is",UserDefaults.standard.string(forKey: "deviceToken")!)
        UserDefaults.standard.set(DEVICE_TOKEN, forKey: "device_token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //        SharedHelper.showAlertView(title: "Error", message: error.localizedDescription)
        print("Failed to register:", error)
        DEVICE_TOKEN = "e34ac7eb71a895f24ce2139ffb1c70d9364702cc6afc7bfa9a4a31b45b474e3e"
        UserDefaults.standard.set(DEVICE_TOKEN, forKey: "deviceToken")
    }
    
    func tokenString(_ deviceToken:Data) -> String{
        //code to make a token string
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        self.token.set(token, forKey: "deviceToken")
        //        UserDefaults.set(token, forKey: "deviceToken")
        return token
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        application.applicationIconBadgeNumber = 0

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        application.applicationIconBadgeNumber = 0

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

