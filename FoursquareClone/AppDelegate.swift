//
//  AppDelegate.swift
//  FoursquareClone
//
//  Created by Onur Bulut on 20.08.2023.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        
        
        let parseConfiguration  = ParseClientConfiguration { ParseMutableClientConfiguration in
            ParseMutableClientConfiguration.applicationId = "HxmqVZ8HZaxR8bIVa3X1Md0yYpsTNQ1O6t3SsYBS"
            ParseMutableClientConfiguration.clientKey = "Inpszs7mdWzSSua63irglsv6W3dbr5VlubDBIOKY"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
            
        }
        
        
        Parse.initialize(with: parseConfiguration)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

