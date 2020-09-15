//
//  SettingsModel.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/15/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation

struct Source {
    var url: URL
    var isActive: Bool
}

protocol SettingsManager {
    func add(fetchedURL: URL)
    func sources() -> [Source]
}

class StubSettingsManager: SettingsManager {
    
    var fetchedSources: [Source] = ["https://www.gazeta.ru/export/rss/first.xml"].map { Source(url: URL(string: $0)!, isActive: true) }
    
    func add(fetchedURL: URL) {
        fetchedSources.append(Source(url: fetchedURL, isActive: true))
    }
    
    func sources() -> [Source] {
        return fetchedSources
    }
}
