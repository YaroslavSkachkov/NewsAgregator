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
    
    let feedFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://lenta.ru/rss/news")!)
    let gazetaFetcher: NetworkFeedFetcher = NetworkFeedFetcher(with: URL(string: "https://www.gazeta.ru/export/rss/first.xml")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        let arr:[NetworkFeedFetcher] = [gazetaFetcher, feedFetcher]
        var counter: Int = 0
        
        #warning("Can be case of race conditions. Should work via DispatchGroup")
        #warning("Вынести в отдельный метод (будет юзаться больше одного раза)")
        arr.enumerated().forEach { [weak self] index, feedFetcher in
            feedFetcher.fetchFeed { result in
                assert(Thread.isMainThread)
                switch result {
                case .success(let fetchFeedItems):
                    counter += 1
                    self?.feedItems += fetchFeedItems
                    if counter == arr.count { self?.tableView.reloadData() }
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        feedCell.titleLabel.text = feedItems[indexPath.row].title
        feedCell.descriptionLabel.text = feedItems[indexPath.row].description
        feedCell.feedImageView.kf.setImage(with: feedItems[indexPath.row].imgURL)
        return feedCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(SFSafariViewController(url: feedItems[indexPath.row].url), animated: true, completion: nil)
    }
}
