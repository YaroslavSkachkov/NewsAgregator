//
//  FeedManager.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/8/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation
import FeedKit

class FeedManager {
    
    static let sharedInstance: FeedManager = {
        return FeedManager()
    }()
    
    private init() {}
    
    func sortByDate(_ feedItems: [FeedItem]) -> [FeedItem] {
        return feedItems.sorted(by: {$0.date > $1.date})
    }
    
}
