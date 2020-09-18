//
//  Errors.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/10/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation

func printError(_ error: Error) {
    print("[\(Date())][NewsAgregator][Internal error][\(error.localizedDescription)]")
}

enum NAError: Error {
    case invalidURLString
    case feedItemParseError
    case invalidFeedType
    case transformationError
    case realmInitializationError
    case writingToDBError
}


extension NAError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURLString:
            return NSLocalizedString("Can't convert input value to URL", comment: "Invalid String")
        case .feedItemParseError:
            return NSLocalizedString("Can't parse fetched feed item", comment: "Feed Item Parser Error")
        case .invalidFeedType:
            return NSLocalizedString("Feed type is not RSS", comment: "Invalid Feed Type")
        case .transformationError:
            return NSLocalizedString("Can't transform fetched feed item", comment: "Transformation Error")
        case .realmInitializationError:
            return NSLocalizedString("Can't initialize Realm database", comment: "Realm Initialization Error")
        case .writingToDBError:
            return NSLocalizedString("Can't write to database", comment: "Database Error")
        }
    }
}
