//
//  FeedFetcher.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/8/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation
import FeedKit

protocol Fetcher {
    var baseURL: URL { get }
    var fetchedItems: [RSSFeedItem] { get }
}

class FeedFetcher: Fetcher {
    
    let stringURL: String
    
    init(with stringURL: String) {
        self.stringURL = stringURL
    }
    
    var baseURL: URL {
        guard let url = URL(string: stringURL) else { return endpointURL }
        return url
    }
    
    var fetchedItems: [RSSFeedItem] {
        return []
    }
    
    func fetchFeed(completion: @escaping ([RSSFeedItem], ParserError?) -> Void) {
        fetchFeed(from: baseURL, completion: completion)
    }
    
    private func fetchFeed(from baseURL: URL, completion: @escaping ([RSSFeedItem], ParserError?) -> Void) {
        let feedParser = FeedParser(URL: baseURL)
        feedParser.parseAsync(queue: .global(qos: .userInitiated)) { [weak self] result in
            if let parsedItems = self?.parseItems(from: result) {
                completion(parsedItems, nil)
            }
        }
    }
    
    private func parseItems(from fetchResult: Result<Feed, ParserError>) -> [RSSFeedItem] {
        switch fetchResult {
        case .success(let feed):
            if let news = feed.rssFeed?.items {
                return news
            }
            print("Error: Parser can't parse feed items")
        case .failure(let error):
            print(error.localizedDescription)
        }
        return []
    }
    
}
