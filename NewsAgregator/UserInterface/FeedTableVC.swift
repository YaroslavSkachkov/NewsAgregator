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

class FeedTableVC: UITableViewController {
    
    var feedItems: [FeedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FeedManager.sharedInstance.loadFeed { [weak self] in
            self?.tableView.reloadData()
        }
        title = "News"
        self.tableView.estimatedRowHeight = 140.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let feedItemsFromRealm = FeedManager.sharedInstance.getFeedItems()
        return feedItemsFromRealm.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = FeedManager.sharedInstance.getFeedItems()[indexPath.row]
        let feedCell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        feedCell.titleLabel.text = feedItem.title
        feedCell.descriptionLabel.text = feedItem.description
        feedCell.feedImageView.kf.setImage(with: feedItem.imgURL)
        feedCell.unread = feedItem.unread
        return feedCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = FeedManager.sharedInstance.getFeedItems()[indexPath.row]
        present(SFSafariViewController(url: feedItem.url), animated: true) {
            FeedManager.sharedInstance.updateUnreadStatus(feedItem, fullyWatched: false)
        }
    }
}
