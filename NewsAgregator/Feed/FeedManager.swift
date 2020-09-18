//
//  FeedManager.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/8/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation
import FeedKit

protocol FeedManagerDelegate: class {
    func onFeedLoaded()
}

protocol FeedManagerProtocol {
    var delegate: FeedManagerDelegate? { get set }
    func getFeedItems() -> [FeedItem]
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool)
}

class FeedManager: FeedManagerProtocol {
    
    weak var delegate: FeedManagerDelegate?
    let databaseManager: DatabaseManagerProtocol
    let settingsManager: Settings
    var timer: Timer?
    
    init(databaseManager: DatabaseManagerProtocol, settingsManager: SettingsManager) {
        self.databaseManager = databaseManager
        self.settingsManager = settingsManager
        self.settingsManager.delegate = self
    }
    
    @objc func refreshViaTimer(timer: Timer) {
        loadFeed {}
    }
    
    @objc func loadFeed(_ completion: @escaping ()->()) {
        print("Load Feed: ", Date())
        let feedGroup = DispatchGroup()
        let activeSources = settingsManager.sources().filter { $0.isActive == true }
        let fetchers = activeSources.map { NetworkFeedFetcher(with: $0.url) }
        var feedItems: [FeedItem] = []
        fetchers.enumerated().forEach { index, feedFetcher in
            feedGroup.enter()
            feedFetcher.fetchFeed { result in
                switch result {
                case .success(let fetchFeedItems):
                    feedItems += fetchFeedItems
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
                feedGroup.leave()
            }
        }

        feedGroup.notify(queue: .main) { [weak self] in
            self?.databaseManager.saveFeedItems(feedItems)
            completion()
            self?.delegate?.onFeedLoaded()
        }
    }
    
    func getFeedItems() -> [FeedItem] {
        return databaseManager.getFeedItems()
    }
    
    func updateUnreadStatus(_ item: FeedItem, fullyWatched: Bool) {
        databaseManager.updateUnreadStatus(item, fullyWatched: fullyWatched)
    }
    
}

extension FeedManager: SettingsManagerDelegate {
    
    func onTimerValueChanged(value: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: value, target: self, selector: #selector(refreshViaTimer(timer:)), userInfo: nil, repeats: true)
    }
}
