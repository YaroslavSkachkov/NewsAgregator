//
//  SettingsVC.swift
//  NewsAgregator
//
//  Created by Ярослав on 9/15/20.
//  Copyright © 2020 YaroslavSkachkov. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    
    @IBOutlet weak var urlTextField: UITextField!
    
    var settingsManager: SettingsManager!
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        fetchers = [gazetaFetcher, lentaFetcher]
        
        self.settingsTable.dataSource = self
        self.settingsTable.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "textFieldCell")
        self.settingsTable.register(UINib(nibName: "FetcherCell", bundle: nil), forCellReuseIdentifier: "fetcherCell")
    }
    
    
    @IBAction func addURL() {
        if let url = URL(string: urlTextField.text ?? "") {
            settingsManager.add(fetchedURL: url)
        } else {
            assertionFailure("Make alert view")
        }
        self.settingsTable.reloadData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsManager.sources().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sources: [Source] = settingsManager.sources()
        let fetcherCell: FetcherCell = tableView.dequeueReusableCell(withIdentifier: "fetcherCell", for: indexPath) as! FetcherCell
        #warning("траблы с хостом, может выводиться без хоста")
        fetcherCell.textLabel?.text = sources[indexPath.row].url.host
        fetcherCell.isActiveSwitch.isOn = sources[indexPath.row].isActive
        return fetcherCell
    }
}
