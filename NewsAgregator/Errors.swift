//
//  Errors.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/10/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation

enum NAError: Error {
    case invalidString
    case feedItemParseError
    case invalidFeedType
}
