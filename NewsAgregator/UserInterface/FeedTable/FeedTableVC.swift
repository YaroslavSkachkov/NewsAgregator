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

protocol FeedTableVCDelegate {
    func onSettingsButtonTapped()
}

#warning("ИСПРАВИТЬ КЕЙС ФЕТЧА НОВОСТИ БЕЗ ДЕСКРИПШЕНА")

class FeedTableVC: UITableViewController {
    
    var feedItems: [FeedItem] = []
    var feedManager: FeedManagerProtocol!
    var delegate: FeedTableVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings))
        self.tableView.estimatedRowHeight = 140.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedManager.loadFeed { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func openSettings() {
        delegate?.onSettingsButtonTapped()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let feedItemsFromRealm = feedManager.getFeedItems()
        return feedItemsFromRealm.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = feedManager.getFeedItems()[indexPath.row]
        let feedCell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        feedCell.titleLabel.text = feedItem.title
        feedCell.descriptionLabel.text = feedItem.description
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