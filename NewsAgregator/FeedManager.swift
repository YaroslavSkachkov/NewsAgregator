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

protocol FeedItemManager {
    func saveFeedItems(_ feedItems: [FeedItem])
    func getFeedItems() -> [FeedItem]
}

class FeedManager: FeedItemManager {
    
    var realm: Realm?
    let feedFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://lenta.ru/rss/news")!)
    let gazetaFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://www.gazeta.ru/export/rss/first.xml")!)
    private var feedItems: [FeedItem] = []
    
    static let sharedInstance: FeedManager = {
        return FeedManager()
    }()
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            assertionFailure(NAError.realmInitializationError.localizedDescription)
        }
    }
    
    func sortByDate(_ feedItems: [FeedItem]) -> [FeedItem] {
        return feedItems.sorted(by: {$0.date > $1.date})
    }
    
    func loadFeed(_ completion: @escaping ()->()) {
        let fetchers: [NetworkFeedFetcher] = [gazetaFetcher, feedFetcher]
        
        var counter: Int = 0
        
        #warning("Can be case of race conditions. Should work via DispatchGroup")
        #warning("Вынести в отдельный метод (будет юзаться больше одного раза)")
        fetchers.enumerated().forEach { [weak self] index, feedFetcher in
            feedFetcher.fetchFeed { result in
                assert(Thread.isMainThread)
                switch result {
                case .success(let fetchFeedItems):
                    counter += 1
                    self?.feedItems += fetchFeedItems
                    if counter == fetchers.count { FeedManager.sharedInstance.saveFeedItems(self?.feedItems ?? []); completion()}
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    func saveFeedItems(_ feedItems: [FeedItem]) {
        if let unwRealm = realm {
            feedItems.forEach { feedItem in
                let feedItemRealmObject: FeedItemRealmObject = FeedTransformer.sharedInstance.transformToFeedItemRealmObj(feedItem)
                do {
                    try unwRealm.write() {
                        if (unwRealm.object(ofType: FeedItemRealmObject.self, forPrimaryKey: feedItemRealmObject.url) == nil) {
                            unwRealm.add(feedItemRealmObject)
                        }
                    }
                } catch {
                    assertionFailure(NAError.writingToDBError.localizedDescription)
                    print(NAError.writingToDBError.localizedDescription)
                }
            }
        }
    }
    
    func getFeedItems() -> [FeedItem] {
        var feedItems: [FeedItem] = []
        if let unwRealm = realm {
            unwRealm.objects(FeedItemRealmObject.self).sorted(by: {$0.date > $1.date}).forEach { feedItem in
                do {
                    try feedItems.append(FeedTransformer.sharedInstance.transformFromFeedItemRealmObj(feedItem))
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
        return feedItems
    }
    
    func removeFeedItem() {
        
    }
    
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool) {
        if let unwRealm = realm {
            do {
                try unwRealm.write() {
                    unwRealm.object(ofType: FeedItemRealmObject.self, forPrimaryKey: item.url.absoluteString)?.unread = fullyWatched
                }
            } catch {
                assertionFailure(NAError.writingToDBError.localizedDescription)
                print(NAError.writingToDBError.localizedDescription)
            }
        }
    }
}
