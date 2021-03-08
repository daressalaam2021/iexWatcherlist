//
//  SymbolSearchResultTableViewController.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/6/21.
//

import UIKit

class SymbolSearchResultTableViewController: UITableViewController {
    
    var symbols: [FollowedSymbol]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SymbolSearchTableViewCell.self, forCellReuseIdentifier: SymbolSearchTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbols?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SymbolSearchTableViewCell.reuseIdentifier, for: indexPath) as? SymbolSearchTableViewCell {
            cell.data = self.symbols?[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
}
