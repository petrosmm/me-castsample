//
//  AppDelegate.swift
//  testcast20190403
//
//  Created by Maximus Peters on 4/3/19.
//

import UIKit
import GoogleCast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var deviceName: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        deviceName = UIDevice.current.name
        print("\(deviceName)")
        print(deviceName == "iPhone SE")

        if (deviceName == "iPhone SE" || deviceName == "iPhoneM")
            { CastManager.shared.initialise() }

                window?.clipsToBounds = true

        let rootContainerVC = (window?.rootViewController as? ViewController)
        rootContainerVC?.miniMediaControlsViewEnabled = true

        // Override point for customization after application launch.

        // Initialize Google Cast SDK
        // we didnt do this here because we do it in the cast managers...

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of /Users/max/Documents/Git/testcast20190403/testcast20190403/testcast20190403.entitlementsapplicationWillTerminate: when the user quits.
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

}

