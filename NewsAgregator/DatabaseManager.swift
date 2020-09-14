//
//  DatabaseManager.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/14/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation
import RealmSwift

protocol DatabaseManagerProtocol {
    func saveFeedItems(_ feedItems: [FeedItem])
    func getFeedItems() -> [FeedItem]
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool)
    func removeFeedItem()
}

class DatabaseManager: DatabaseManagerProtocol {
    
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func saveFeedItems(_ feedItems: [FeedItem]) {
        feedItems.forEach { feedItem in
            let feedItemRealmObject: FeedItemRealmObject = FeedTransformer.sharedInstance.transformToFeedItemRealmObj(feedItem)
            do {
                try realm.write() {
                    if (realm.object(ofType: FeedItemRealmObject.self, forPrimaryKey: feedItemRealmObject.url) == nil) {
                        realm.add(feedItemRealmObject)
                    }
                }
            } catch {
                assertionFailure(NAError.writingToDBError.localizedDescription)
                print(NAError.writingToDBError.localizedDescription)
            }
        }
    }
    
    func getFeedItems() -> [FeedItem] {
        var feedItems: [FeedItem] = []
        realm.objects(FeedItemRealmObject.self).sorted(by: {$0.date > $1.date}).forEach { feedItem in
            do {
                try feedItems.append(FeedTransformer.sharedInstance.transformFromFeedItemRealmObj(feedItem))
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        return feedItems
    }
    
    func removeFeedItem() {
        #warning("TODO")
    }
    
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool) {
        do {
            try realm.write() {
                realm.object(ofType: FeedItemRealmObject.self, forPrimaryKey: item.url.absoluteString)?.unread = fullyWatched
            }
        } catch {
            assertionFailure(NAError.writingToDBError.localizedDescription)
            print(NAError.writingToDBError.localizedDescription)
        }
    }
}


