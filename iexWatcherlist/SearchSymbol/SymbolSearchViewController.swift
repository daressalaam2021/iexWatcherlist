//
//  SymbolSearchViewController.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation
import UIKit

class SymbolSearchViewController: UIViewController {
    
    private lazy var resultController: SymbolSearchResultTableViewController = {
        let vc = SymbolSearchResultTableViewController()
        vc.tableView.delegate = self
        return vc
    }()
    
    private lazy var searchController: UISearchController = {
        UISearchController(searchResultsController: resultController)
    }()
    
    private let emptyView = EmptyView(text: "Symbols not found")
    
    private let api: ApiSymbol
    private let watchlist: Set<String>
    var onSymbolFollowed: ((Symbol) -> Void)?
    
    init(api: ApiSymbol, currentWatchlist: Set<String>) {
        self.watchlist = currentWatchlist
        self.api = api
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.title = "Search A Symbol"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a Symbol"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsScopeBar = false
        searchController.searchBar.searchTextField.textColor = .label
    }
    
    private func searchSymbol(_ query: String) {
        guard !query.isEmpty else { return }
        let cleanString = query.trimmingCharacters(in: .whitespacesAndNewlines)
        self.api.getSymbols(with: cleanString) { (result) in
            switch result {
            case .success(let rawSymbols):
                guard !rawSymbols.isEmpty else { fallthrough }
                // convert symbols to followed based on watchlist
                let followedSymbols: [FollowedSymbol] = rawSymbols.map {
                    if self.watchlist.contains($0.symbol) {
                        return FollowedSymbol(symbol: $0, isInCurrentWatchlist: true)
                    } else {
                        return FollowedSymbol(symbol: $0, isInCurrentWatchlist: false)
                    }
                }
                self.resultController.symbols = followedSymbols
                
            default:
                self.resultController.symbols = nil
                self.view.bringSubviewToFront(self.emptyView)
            }
        }
    }
    
    private func searchFor(_ searchText: String?) {
        guard searchController.isActive else { return }
        guard let searchText = searchText else {
            resultController.symbols = nil
            return
        }
        
        searchSymbol(searchText)
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UISearchBarDelegate
extension SymbolSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultController.symbols = nil
        searchController.searchBar.searchTextField.backgroundColor = nil
    }
}

// MARK: - UISearchResultsUpdating
extension SymbolSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.searchTextField.isFirstResponder {
            self.view.sendSubviewToBack(emptyView)
            searchController.showsSearchResultsController = true
            searchController.searchBar.searchTextField.backgroundColor = UIColor.green.withAlphaComponent(0.1)
        } else {
            searchController.searchBar.searchTextField.backgroundColor = nil
            self.view.bringSubviewToFront(emptyView)
        }
    }
}

// MARK: - UITableViewDelegate
extension SymbolSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let symbol = self.resultController.symbols?[indexPath.row] else { return }
        symbol.isInCurrentWatchlist.toggle()
        self.onSymbolFollowed?(symbol.symbol)
    }
}
