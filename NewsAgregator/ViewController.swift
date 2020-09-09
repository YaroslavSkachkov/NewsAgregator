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
    let feedFetcher = FeedFetcher(with: "https://lenta.ru/rss/news")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedFetcher.fetchFeed { feedItems, error in
            print(feedItems)
        }
    }
    

}
