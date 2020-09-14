//
//  Errors.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/10/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation

#warning("Add more error cases. Add descriptions")
enum NAError: Error {
    case invalidString
    case feedItemParseError
    case invalidFeedType
    case transformationError
    case realmInitializationError
    case writingToDBError
}
