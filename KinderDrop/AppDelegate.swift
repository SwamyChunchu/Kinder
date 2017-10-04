//
//  AppDelegate.swift
//  KinderDrop
//
//  Created by amit on 4/5/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn
import CoreLocation
import Stripe
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate
{
    
    var window: UIWindow?
    
    var locationManager = CLLocationManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var splashView = UIView()
    var deviceTokenStr = String()
    
    var latitudeSrtAPD = String()
    var longitudeSrtAPD = String()
    var fiveStarStrAD = String()
    var fourStarStrAD = String()
    var threeStarStrAD = String()
    var fullDayStrAD = String()
    var firstHlfStrAD = String()
    var secondHlfStrAD = String()
    var selectionChildArrayAD = NSMutableArray()
    var fromDateTxtAPD = NSString()
    var toDateTxtAPD = NSString()
    
    var ratingStringFltrAPD = String()
    var priceStringFltrAPD = String()
    var capabilityStringFltrAPD = String()
    
    var searchDoubleLat = Double()
    var searchDoubleLong = Double()

    var userIDCount = String()
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        UserDefaults.standard.setValue("firstOpen", forKey: "open")
        
        UserDefaults.standard.removeObject(forKey: "LatutudeSave")
        UserDefaults.standard.removeObject(forKey: "LongitudeSave")
        UserDefaults.standard.removeObject(forKey: "selectedName")
         //Thread.sleep(forTimeInterval: 0.01)
        
         UIApplication.shared.applicationIconBadgeNumber = 0
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
//      currentLatitude = (locationManager.location?.coordinate.latitude)!
//      currentLongitude = (locationManager.location?.coordinate.longitude)!

        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        GMSServices.provideAPIKey("AIzaSyDjQQYoaF21Nu4QRbADRdMdI-NHIaJ9Ek4")
        GMSPlacesClient.provideAPIKey("AIzaSyDjQQYoaF21Nu4QRbADRdMdI-NHIaJ9Ek4")

        Stripe.setDefaultPublishableKey("pk_test_sspHXvIqTTHX6uI8WlqpJ0Jk")
        
//        Initialize sign-in
//        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
//        let userID = UserDefaults.standard.object(forKey: "success")
//        if (userID == nil)
//        {
//            UserDefaults.standard.set("UnSuccess", forKey: "success")
//        }else
//        {
//            if UserDefaults.standard.object(forKey: "success") as! String == "LoginSuccess"
//            {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let mvc: TabBarViewController? = (storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController)
//                window?.rootViewController = mvc
//            }
//            else
//            {
//                UserDefaults.standard.set("UnSuccess", forKey: "success")
//            }
//        }
        self.registerPushNotifications()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//       // let userLocation:CLLocation = locations.last!
//    }
    
    
    func registerPushNotifications()
    {
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler:
                { granted, error in
                    
                    if granted {
                        UIApplication.shared.registerForRemoteNotifications()
                    } else {
                        // Unsuccessful...
                    }
            })
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
 
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if !url.absoluteString.contains("419586301732585")
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else{
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
         FBSDKAppEvents.activateApp()
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil) {
            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            // ...
        } else {
        }
    }
    
//MARK: Get Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "DeviceToken")
        UserDefaults.standard.synchronize()
        print(deviceTokenString)
    }
    // Called when APNs failed to register the device for push notifications
    @nonobjc func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    // Print the error to console (you should alert the user that registration failed)
    }

 //MARK: Push Notification Methods
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        
      //  print(response.notification.request.content.userInfo)
        _ = response.notification.request.content.userInfo as NSDictionary
        
        UserDefaults.standard.set("Received", forKey: "NotificationRecived")
        
        let userID = UserDefaults.standard.object(forKey: "success")
        if (userID == nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LaunchAnimateVC") as! LaunchAnimateVC
            let navigationController = self.window?.rootViewController as! UINavigationController
            navigationController.pushViewController(destinationViewController, animated: false)
           // UserDefaults.standard.set("UnSuccess", forKey: "success")
        }
        else
            {
            
           if UserDefaults.standard.object(forKey: "success") as! String == "LoginSuccess"
              {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mvc: NotificationVC? = (storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC)
                let navigation = UINavigationController.init(rootViewController: mvc!)
                navigation .setNavigationBarHidden(true, animated: true)
                self.window?.rootViewController=navigation
             }
              else
             {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LaunchAnimateVC") as! LaunchAnimateVC
                let navigationController = self.window?.rootViewController as! UINavigationController
                navigationController.pushViewController(destinationViewController, animated: false)
            }
        }
        
        //self.window?.makeKeyAndVisible()
//        if let aps = dic["aps"] as? [String: Any] {
//        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
       // print(notification.request.content.userInfo)
//        let dic = notification.request.content.userInfo as NSDictionary
//        if let aps = dic["aps"] as? [String: Any] {
//        }
        
        userIDCount = UserDefaults.standard.value(forKey: "saveUserID") as! String
        self.badgeCountAPImethod()
        
        
    }
    
    func badgeCountAPImethod () -> Void
    {
        let baseURL: String  = String(format: "%@usercount/",Constants.mainURL)
        let  params = "userid=\(userIDCount)"
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            //AFWrapperClass.svprogressHudDismiss(view: self)
            DispatchQueue.main.async {
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    let countStr:String = (dic.object(forKey:"data") as! NSDictionary).object(forKey:"count") as! String
                    
                    if countStr == "0"
                    {
//       countStr = "5"
//       NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: countStr)
                        
                    }else{
                        
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: countStr)
                    
                    }
                }
                else
                {
                // AFWrapperClass.svprogressHudDismiss(view: self)
                // AFWrapperClass.alert(Constants.applicationName, message: "No DayCare Found", view: self)
                }
            }
        })
        { (error) in
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }

    
}

