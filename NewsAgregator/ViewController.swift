//
//  ViewController.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/8/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit
import FeedKit

class ViewController: UIViewController {
    
    var fetchedItems: [RSSFeedItem] = []
    let stringURL = "https://lenta.ru/rss/news"
    let gazetaURL = "https://www.gazeta.ru/export/rss/first.xml"
    let feedFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://lenta.ru/rss/news")!)
    let gazetaFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://www.gazeta.ru/export/rss/first.xml")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arr:[NetworkFeedFetcher] = [gazetaFetcher, feedFetcher]
        var counter: Int = 0
        var feedItemsArr: [FeedItem] = []
        arr.enumerated().forEach { index, feedFetcher in
            print("[ForEach:\(index)] --- ")
            feedFetcher.fetchFeed { result in
                print("[FetchFeed:\(index)] --- ")
                assert(Thread.isMainThread)
                switch result {
                case .success(let feedItems):
                    counter += 1
                    feedItemsArr += feedItems
                    if counter == arr.count { print("\(FeedManager.sharedInstance.sortByDate(feedItemsArr)) \n") }
                case .failure(let error):
                    assert(true, error.localizedDescription)
                }
            }
        }
    }
    
    
}
