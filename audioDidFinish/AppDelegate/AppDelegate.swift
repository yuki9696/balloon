//
//  AppDelegate.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 27/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Navigation Background color in appdelegate
        
        UINavigationBar.appearance().barTintColor = UIColor.init(red: (26.0/255.0), green: (173.0/255.0), blue: (120.0/255.0), alpha: (1.0/255.0))
        
        
        //Navigation Bar color in appdelegate
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //Navigation Bar title text color in appdelegate
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Status Bar light content in appdelegate
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        // Override point for customization after application launch.
        _ = PLIST.shared
        return true
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
        PLIST.shared.write()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

