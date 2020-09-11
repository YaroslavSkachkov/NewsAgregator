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
    
    func transformFeedItems(_ feedItems: [RSSFeedItem],
                            from url: URL) -> [FeedItem] {
        var transformedFeedItems: [FeedItem] = []
        feedItems.forEach { feedItem in
            do {
                transformedFeedItems.append(try transformFeedItem(feedItem, from: url))
            } catch {
                print(error.localizedDescription)
            }
        }
        return transformedFeedItems
    }
    
    private func transformFeedItem(_ feedItem: RSSFeedItem,
                                     from url: URL) throws -> FeedItem {
        if let title: String = feedItem.title,
            let description: String = feedItem.description?.trimmingCharacters(in: .whitespacesAndNewlines),
            let source: String = url.host,
            let feedItemURLString: String = feedItem.link,
            let feedItemURL: URL = URL(string: feedItemURLString),
            let enclosure: RSSFeedItemEnclosure = feedItem.enclosure,
            let attributes: RSSFeedItemEnclosure.Attributes = enclosure.attributes,
            let imgURLString: String = attributes.url,
            let imgURL: URL = URL(string: imgURLString),
            let date: Date = feedItem.pubDate {
            return FeedItem(date: date,
                           title: title,
                     description: description,
                          imgURL: imgURL,
                             url: feedItemURL,
                          source: source)
        }
        assertionFailure(NAError.transformationError.localizedDescription)
        throw NAError.transformationError
    }
}
