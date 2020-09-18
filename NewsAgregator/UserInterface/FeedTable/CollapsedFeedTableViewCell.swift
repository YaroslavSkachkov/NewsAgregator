//
//  CollapsedFeedTableViewCell.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/18/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit

class CollapsedFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    var feedStatusView = FeedStatusView(frame: .zero)
    var unread = false {
           didSet {
               feedStatusView.transform = unread ? CGAffineTransform.identity : CGAffineTransform.init(scaleX: 0.001, y: 0.001)
           }
       }
    var animator: Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFeedStatusView()
        feedImageView.layer.cornerRadius = feedImageView.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFeedStatusView() {
        feedStatusView.translatesAutoresizingMaskIntoConstraints = false
        feedStatusView.color = .orange
        feedStatusView.backgroundColor = .clear
        contentView.addSubview(feedStatusView)
        
        let size: CGFloat = 12
        feedStatusView.widthAnchor.constraint(equalToConstant: size).isActive = true
        feedStatusView.heightAnchor.constraint(equalTo: feedStatusView.widthAnchor).isActive = true
        feedStatusView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        feedStatusView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
    }
    
}
