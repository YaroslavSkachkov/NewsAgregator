//
//  SettingsModel.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/15/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation
import RealmSwift

struct Source {
    var url: URL
    var isActive: Bool
}

class SourceRealmObject: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var isActive: Bool = true
    
    override class func primaryKey() -> String? {
        return "url"
    }
}

protocol Settings {
    func add(fetchedURL: URL)
    func sources() -> [Source]
    func changeSourceActiveness(url: URL, active: Bool)
}

class SettingsManager: Settings {
    
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
//    https://www.gazeta.ru/export/rss/first.xml
    
    func add(fetchedURL: URL) {
        let sourceRealmObject = SourceRealmObject()
        sourceRealmObject.url = fetchedURL.absoluteString
        sourceRealmObject.isActive = true
        do {
            try realm.write() {
                if (realm.object(ofType: SourceRealmObject.self, forPrimaryKey: sourceRealmObject.url) == nil) {
                    realm.add(sourceRealmObject)
                }
            }
        } catch {
            assertionFailure(NAError.writingToDBError.localizedDescription)
            print(NAError.writingToDBError.localizedDescription)
        }
    }
    
    func sources() -> [Source] {
        return realm.objects(SourceRealmObject.self).map{ Source(url: URL(string: $0.url)!, isActive: $0.isActive) }
    }
    
    func changeSourceActiveness(url: URL, active: Bool) {
        do {
            try realm.write() {
                realm.object(ofType: SourceRealmObject.self, forPrimaryKey: url.absoluteString)?.isActive = active
            }
        } catch {
            assertionFailure(NAError.writingToDBError.localizedDescription)
            print(NAError.writingToDBError.localizedDescription)
        }
    }
}
