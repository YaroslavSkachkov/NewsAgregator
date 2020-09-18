//
//  FeedItem.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/9/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation
import RealmSwift

struct FeedItem {
    var date: Date
    var title: String
    var description: String
    var imgURL: URL?
    var url: URL
    var source: String
    var unread: Bool
}

class FeedItemRealmObject: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var feedTitle: String = ""
    @objc dynamic var feedDescription: String = ""
    @objc dynamic var imgURL: String? = nil
    @objc dynamic var url: String = ""
    @objc dynamic var source: String = ""
    @objc dynamic var unread: Bool = true
    
    override class func primaryKey() -> String? {
        return "url"
    }
}
