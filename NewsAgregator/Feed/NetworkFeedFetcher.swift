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
    func fetchFeed(completion: @escaping (Result<[FeedItem], Error>) -> Void)
}

class NetworkFeedFetcher: Fetcher {
    
    let url: URL
    
    init(with baseURL: URL) {
        self.url = baseURL
    }
    
    func fetchFeed(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        FeedParser(URL: url).parseAsync(queue: .global(qos: .userInitiated)) { [url] result in
            DispatchQueue.main.async {
                do {
                    completion(.success(try result.parseItems(from: url)))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}

extension Result where Success == Feed {
    func parseItems(from url: URL) throws -> [FeedItem] {
        switch self {
        case .success(let feed):
            if let feedItems = feed.rssFeed?.items {
                return FeedTransformer.sharedInstance.transformFeedItems(feedItems, from: url)
            }
            assertionFailure("Invalid feed type (not RSS)")
            throw NAError.invalidFeedType
        case .failure(let error):
            throw error
        }
    }
}
