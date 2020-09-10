//
//  FeedItem.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/9/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit

struct FeedItem {
    var date: Date
    var title: String
    var description: String
    var imgURL: URL
    var url: URL // Здесь лучше заюзать УРЛ потому что у урла есть куча пропертей, чтобы мы во всей прилаги оперировали только урлом а достали его ТОЛЬКО В ОДНОМ МЕСТЕ
    var source: String
}
