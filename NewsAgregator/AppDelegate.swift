//
//  AppDelegate.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/8/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        let feedTableVC = FeedTableVC()
        let navController = UINavigationController(rootViewController: feedTableVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

