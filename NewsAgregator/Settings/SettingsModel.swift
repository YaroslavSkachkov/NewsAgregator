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
