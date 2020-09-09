//
//  Extensions.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/9/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation

extension URL {
    var rssSource: String {
        var source: String = ""
        if let unwHost = host {
            source = unwHost
            source.removeSubrange(source.firstIndex(of: ".")!..<source.endIndex)
            source.capitalizeFirstLetter()
        }
        return source
    }
}

extension String {
    private func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
