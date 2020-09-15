//
//  FeedTransformer.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/9/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit
import FeedKit

#warning("FeedItem models should be improved in case of unusual rss model (like from buzzfeed.com)")

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
    
    func transformToFeedItemRealmObj(_ feedItem: FeedItem) -> FeedItemRealmObject {
        let feedItemRealmObject = FeedItemRealmObject()
        feedItemRealmObject.date = feedItem.date
        feedItemRealmObject.feedTitle = feedItem.title
        feedItemRealmObject.feedDescription = feedItem.description
        feedItemRealmObject.imgURL = feedItem.imgURL?.absoluteString
        feedItemRealmObject.url = feedItem.url.absoluteString
        feedItemRealmObject.source = feedItem.source
        feedItemRealmObject.unread = feedItem.unread
        return feedItemRealmObject
    }
    
    func transformFromFeedItemRealmObj(_ realmFeedItem: FeedItemRealmObject) throws -> FeedItem {
        if let imgURL = URL(string: realmFeedItem.imgURL ?? ""),
           let url = URL(string: realmFeedItem.url) {
            return FeedItem(date: realmFeedItem.date,
                  title: realmFeedItem.feedTitle,
            description: realmFeedItem.feedDescription,
                 imgURL: imgURL,
                    url: url,
                 source: realmFeedItem.source,
                 unread: realmFeedItem.unread)
        }
        throw NAError.transformationError
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
                          source: source,
                          unread: true)
        }
        assertionFailure(NAError.transformationError.localizedDescription)
        throw NAError.transformationError
    }
}
