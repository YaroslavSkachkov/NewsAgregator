//
//  FeedTransformer.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/9/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit
import FeedKit

class FeedTransformer {
    
    static let sharedInstance: FeedTransformer = {
        return FeedTransformer()
    }()
    
    private init() { }
    
    #warning("Print Error in case of invalid feedItem")
    func transformFeedItems(_ feedItems: [RSSFeedItem],
                            from url: URL) -> [FeedItem] {
        var transformedFeedItems: [FeedItem] = []
        feedItems.forEach { feedItem in
            #warning("Force unwrapped optional feedItem")
            transformedFeedItems.append(transformFeedItem(feedItem, from: url)!)
        }
        return transformedFeedItems
    }
    
    
    #warning("Make throwable")
    private func transformFeedItem(_ feedItem: RSSFeedItem,
                                   from url: URL) -> FeedItem? {
        let title: String = feedItem.title ?? ""
        let description: String = feedItem.description ?? ""
        #warning("Force unwrapped optional")
        let source: String = url.host!
        
        if let feedItemURL = try? feedItem.link?.toURL(),
            let enclosure = feedItem.enclosure,
            let attributes = enclosure.attributes,
            let imgURL = try? attributes.url?.toURL(),
            let date = feedItem.pubDate {
            return FeedItem(date: date,
                            title: title,
                            description: description,
                            imgURL: imgURL,
                            url: feedItemURL,
                            source: source)
        }
        assertionFailure()
        return nil
    }
}
