//
//  FeedManager.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/8/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation
import FeedKit
import RealmSwift

protocol FeedManagerProtocol {
    func loadFeed(_ completion: @escaping ()->())
    func getFeedItems() -> [FeedItem]
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool)
}

class FeedManager: FeedManagerProtocol {
    
    let databaseManager: DatabaseManagerProtocol
    let fetchers: [NetworkFeedFetcher]
    
    init(databaseManager: DatabaseManagerProtocol, fetchers: [NetworkFeedFetcher]) {
        self.databaseManager = databaseManager
        self.fetchers = fetchers
    }
    
    func sortByDate(_ feedItems: [FeedItem]) -> [FeedItem] {
        return feedItems.sorted(by: {$0.date > $1.date})
    }
    
    func loadFeed(_ completion: @escaping ()->()) {
        
        var feedItems: [FeedItem] = []
        var counter: Int = 0
        
        #warning("Can be case of race conditions. Should work via DispatchGroup")
        #warning("Вынести в отдельный метод (будет юзаться больше одного раза)")
        fetchers.enumerated().forEach { [weak self] index, feedFetcher in
            feedFetcher.fetchFeed { result in
                assert(Thread.isMainThread)
                switch result {
                case .success(let fetchFeedItems):
                    counter += 1
                    feedItems += fetchFeedItems
                    if counter == self?.fetchers.count {
                        self?.databaseManager.saveFeedItems(feedItems)
                        completion()
                    }
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    func getFeedItems() -> [FeedItem] {
        return databaseManager.getFeedItems()
    }
    
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool) {
        databaseManager.updateUnreadStatus(item, fullyWatched: fullyWatched)
    }
    
}
