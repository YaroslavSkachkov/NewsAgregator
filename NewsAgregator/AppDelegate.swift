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
    
    let lentaFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://lenta.ru/rss/news")!)
    let gazetaFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://www.gazeta.ru/export/rss/first.xml")!)
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        let feedTableVC = FeedTableVC()
        feedTableVC.feedManager = FeedManager(databaseManager: DatabaseManager(realm: try! Realm()), fetchers: [lentaFetcher, gazetaFetcher])
        let navController = UINavigationController(rootViewController: feedTableVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

