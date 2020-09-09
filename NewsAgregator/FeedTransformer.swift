//
//  FeedTransformer.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/9/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit
import FeedKit

class FeedTransformer {
    
    static let sharedInstance: FeedTransformer = {
        return FeedTransformer()
    }()
    
    private init() { }
    
    func transformFeedItems(_ feedItems: [RSSFeedItem],
                               from url: URL,
                             completion: @escaping ([FeedItem]) -> Void) {
        var transformedFeedItems: [FeedItem] = []
        feedItems.forEach { feedItem in
            transformFeedItem(feedItem, from: url) { feedItem in
                transformedFeedItems.append(feedItem)
            }
        }
        completion(transformedFeedItems)
    }
    
    private func transformFeedItem(_ feedItem: RSSFeedItem,
                                     from url: URL,
                                   completion: @escaping (FeedItem) -> Void) {
        let title: String = feedItem.title ?? ""
        let feedItemURL: String = feedItem.link ?? ""
        let description: String = feedItem.description ?? ""
        let source: String = url.rssSource
        let img: UIImage = UIImage()
        
        if let enclosure = feedItem.enclosure, let attributes = enclosure.attributes, let imgURL = attributes.url {
            
            loadImage(from: URL(string: imgURL)!) { image in
                completion(FeedItem(title: title,
                description: description,
                        img: image,
                        url: feedItemURL,
                     source: source))
            }
            
        }
        
        completion(FeedItem(title: title,
                      description: description,
                              img: img,
                              url: feedItemURL,
                           source: source))
    }
    
    private func loadImage(from url: URL,
                         completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
}
