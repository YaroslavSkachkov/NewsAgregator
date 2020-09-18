//
//  AppDelegate.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/8/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var navController: UINavigationController?
    var window: UIWindow?
    let databaseManager: DatabaseManager = DatabaseManager(realm: try! Realm())
    let settingsManager: SettingsManager = SettingsManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        
        let feedTableVC = FeedTableVC()
        feedTableVC.delegate = self
        settingsManager.databaseManager = databaseManager
        feedTableVC.feedManager = FeedManager(databaseManager: databaseManager, settingsManager: settingsManager)
        navController = UINavigationController(rootViewController: feedTableVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate: FeedTableVCDelegate {
    func onSettingsButtonTapped() {
        let settingsVC = SettingsVC()
        settingsVC.settingsManager = settingsManager
        navController!.pushViewController(settingsVC, animated: true)
    }
}
