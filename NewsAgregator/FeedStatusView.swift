//
//  FeedStatusView.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/13/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit

class FeedStatusView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}
