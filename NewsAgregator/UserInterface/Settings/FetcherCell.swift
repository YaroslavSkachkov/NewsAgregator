//
//  FetcherCell.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/15/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit

class FetcherCell: UITableViewCell {
    
    typealias SwitchCallback = (Bool) -> Void
    var switchCallback: SwitchCallback?

    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var isActiveSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func switchChangedState(_ sender: UISwitch) {
        switchCallback?(sender.isOn)
    }
}
