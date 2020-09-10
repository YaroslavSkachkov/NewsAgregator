//
//  Extensions.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/9/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation

extension String {
    private func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    #warning("Use default URL constructor with if-let")
    func toURL() throws -> URL {
        guard let url = URL(string: self) else { throw NAError.invalidString }
        return url
    }
}

