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
    
    var url: URL = URL(fileURLWithPath: "")
    var news: [FeedKit.RSSFeedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lentaURL = URL(string: "https://lenta.ru/rss/news")
        if let unwrappedURL = lentaURL {
            url = unwrappedURL
        }
        let feedParser = FeedParser(URL: url)
        feedParser.parseAsync(queue: .global(qos: .userInitiated)) {[weak self] result in
            if let news = self?.getNews(result) {
                print(news)
            }
            
        }
    }
    
    private func getNews(_ result: (Result<FeedKit.Feed, FeedKit.ParserError>)) -> [FeedKit.RSSFeedItem] {
        switch result {
        case .success(let feed):
            if let news = feed.rssFeed?.items {
                return news
            }
            print("Parser can't parse feed items")
        case .failure(let error):
            print(error)
        }
        return []
    }
}
