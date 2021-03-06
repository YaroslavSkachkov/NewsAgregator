//
//  FeedTableVC.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/11/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit
import SafariServices
import Kingfisher

protocol FeedTableVCDelegate: class {
    func onSettingsButtonTapped()
}

class FeedTableVC: UITableViewController {
    
    var feedItems: [FeedItem] = []
    var isExpand: Bool = true
    var feedManager: FeedManagerProtocol!
    weak var delegate: FeedTableVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedManager.delegate = self
        title = "News"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Expand", style: .plain, target: self, action: #selector(expandFeedItems))
        
        self.tableView.estimatedRowHeight = 140.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        self.tableView.register(UINib(nibName: "CollapsedFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "collapsedFeedCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @objc private func openSettings() {
        delegate?.onSettingsButtonTapped()
    }
    
    @objc private func expandFeedItems() {
        if isExpand {
            self.tableView.reloadData()
            isExpand = false
        } else {
            self.tableView.reloadData()
            isExpand = true
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let feedItemsFromRealm = feedManager.getFeedItems()
        return feedItemsFromRealm.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = feedManager.getFeedItems()[indexPath.row]
        if isExpand {
            let feedCell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
            feedCell.sourceLabel.text = feedItem.source
            feedCell.titleLabel.text = feedItem.title
            feedCell.descriptionLabel.text = feedItem.description
            feedCell.feedImageView.kf.setImage(with: feedItem.imgURL)
            feedCell.unread = feedItem.unread
            return feedCell
        }
        let feedCell: CollapsedFeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "collapsedFeedCell", for: indexPath) as! CollapsedFeedTableViewCell
        feedCell.sourceLabel.text = feedItem.source
        feedCell.titleLabel.text = feedItem.title
        feedCell.feedImageView.kf.setImage(with: feedItem.imgURL)
        feedCell.unread = feedItem.unread
        return feedCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = feedManager.getFeedItems()[indexPath.row]
        present(SFSafariViewController(url: feedItem.url), animated: true) { [weak self] in
            self?.feedManager.updateUnreadStatus(feedItem, fullyWatched: false)
        }
    }
}

extension FeedTableVC: FeedManagerDelegate {
    
    func onFeedLoaded() {
        tableView.reloadData()
    }
    
}
