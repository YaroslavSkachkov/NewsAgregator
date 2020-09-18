//
//  SettingsManager.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/18/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import Foundation

protocol SettingsManagerDelegate: class {
    func onTimerValueChanged(value: TimeInterval)
    func onNewSourceAdded()
}

protocol Settings: class {
    var delegate: SettingsManagerDelegate? { get set }
    var refreshInterval: TimeInterval { get set }
    func add(fetchedURL: URL)
    func sources() -> [Source]
    func changeSourceActiveness(url: URL, active: Bool)
}

class SettingsManager: Settings {
    
    var databaseManager: DatabaseManagerProtocol?
    weak var delegate: SettingsManagerDelegate?
    
    var refreshInterval: TimeInterval = 60.0 {
        didSet {
            delegate?.onTimerValueChanged(value: refreshInterval)
        }
    }
    
    func add(fetchedURL: URL) {
        databaseManager?.saveSources(from: fetchedURL)
        delegate?.onNewSourceAdded()
    }
    
    func sources() -> [Source] {
        return databaseManager?.getSettingsSources() ?? []
    }
    
    func changeSourceActiveness(url: URL, active: Bool) {
        databaseManager?.updateSourceActiveness(url: url, active: active)
    }
}
