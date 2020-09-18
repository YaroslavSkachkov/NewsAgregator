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
    func saveSources(from url: URL)
    func getSettingsSources() -> [Source]
    func updateSourceActiveness(url: URL, active: Bool)
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
                printError(NAError.writingToDBError)
                printError(error)
            }
        }
    }
    
    func getFeedItems() -> [FeedItem] {
        var feedItems: [FeedItem] = []
        realm.objects(FeedItemRealmObject.self).sorted(by: {$0.date > $1.date}).forEach { feedItem in
            do {
                try feedItems.append(FeedTransformer.sharedInstance.transformFromFeedItemRealmObj(feedItem))
            } catch {
                printError(error)
            }
        }
        return feedItems
    }
    
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool) {
        do {
            try realm.write() {
                realm.object(ofType: FeedItemRealmObject.self, forPrimaryKey: item.url.absoluteString)?.unread = fullyWatched
            }
        } catch {
            printError(NAError.writingToDBError)
            printError(error)
        }
    }
    
    // Settings
    
    func saveSources(from url: URL) {
        let sourceRealmObject = SourceRealmObject()
        sourceRealmObject.url = url.absoluteString
        sourceRealmObject.isActive = true
        do {
            try realm.write() {
                if (realm.object(ofType: SourceRealmObject.self, forPrimaryKey: sourceRealmObject.url) == nil) {
                    realm.add(sourceRealmObject)
                }
            }
        } catch {
            printError(NAError.writingToDBError)
            printError(error)
        }
    }
    
    func getSettingsSources() -> [Source] {
        return realm.objects(SourceRealmObject.self).map{ Source(url: URL(string: $0.url)!, isActive: $0.isActive) }
    }
    
    func updateSourceActiveness(url: URL, active: Bool) {
        do {
            try realm.write() {
                realm.object(ofType: SourceRealmObject.self, forPrimaryKey: url.absoluteString)?.isActive = active
            }
        } catch {
            printError(NAError.writingToDBError)
            printError(error)
        }
    }
    
}


