//
//  FetcherCell.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/15/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit

class FetcherCell: UITableViewCell {

    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var isActiveSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
