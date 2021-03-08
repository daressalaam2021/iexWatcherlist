//
//  WatchlistViewModel.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/3/21.
//

import Foundation
import UIKit
import CoreData
import Combine

class WatchlistViewModel {
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context: NSManagedObjectContext = {
        self.delegate.persistentContainer.viewContext
    }()
    private let api: ApiQuote
    
    var timer: AnyCancellable?
    var updatedWatchlists = [Watchlist]()
    @Published
    var currentWatchlist: Watchlist?
    @Published
    public private(set) var batches: [MarketBatch]
    
    init(api: ApiQuote) {
        self.api = api
        self.batches = [MarketBatch]()
        getLocalUpdatedWatchlists { [weak self] (watchlists) in
            guard let self = self else { return }
            self.updatedWatchlists = watchlists
            self.currentWatchlist = watchlists.first
        }
    }
    
    func getNewestQuotes(type: BatchDataType) {
        guard let currentWatchlist = currentWatchlist, let symbols = currentWatchlist.symbols, !symbols.isEmpty else {
            self.batches = []
            return
        }
        
        api.getQuotes(with: symbols, type: type) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let batches):
                if type == .all {
                    self.batches = batches.sorted()
                } else if type == .quote {
                    // don't want to erase history data
                    let updated: [MarketBatch?] = batches.map { (batch: MarketBatch) in
                        if let history = self.batches.filter({ (value: MarketBatch) in
                            value.quote.symbol == batch.quote.symbol
                        }).first?.historyPrices {
                            return MarketBatch(quote: batch.quote, historyPrices: history)
                        }
                        return nil
                    }
                    self.batches = updated.compactMap { $0 }.sorted()
                }
            case .failure(_):
                break
            }
        }
    }
    
    // update quotes every certain seconds (don't update history prices here since its dataweight is too high and 30 days data won't change within 5 seconds)
    func updateBatch(by seconds: TimeInterval = 5) {
        self.timer = Timer.publish(every: seconds, on: .main, in: .common).autoconnect().sink { [weak self] (output) in
            guard let self = self else { return }
            self.getNewestQuotes(type: .quote)
        }
    }
    
    func updateWatchlists(with action: DataActionType) {
        switch action {
        case .create(let name):
            // create a watch list with name
            updatedWatchlists.append(self.createWatchList(name: name, isDefault: false))
        case .add(let symbol):
            // add a symbol to current list
            self.addSymbolToList(symbol: symbol)
        case .remove(let symbol):
            // remove a symbol from current list
            self.removeSymbolToList(symbol: symbol)
        case .delete(let watchlist):
            // delete a watchlist from app
            self.deleteWatchlist(watchlist)
        }
    }
}

private extension WatchlistViewModel {
    
    var initializeDefaultWatchlist: Watchlist? {
        guard delegate.isFirstLaunch else { return nil }
        return createWatchList(name: "My first list", isDefault: true)
    }
    
    // create a watch list and save to local database
    @discardableResult
    func createWatchList(name: String, isDefault: Bool) -> Watchlist {
        let watchlist = Watchlist(context: context)
        let date = Date()
        watchlist.createdAt = date
        watchlist.id = UUID()
        watchlist.lastUpdatedAt = date
        watchlist.name = name
        let defaultSet: Set<String> = ["AAPL", "MSFT", "GOOG"]
        watchlist.symbols = isDefault ? defaultSet : Set<String>()
        delegate.saveContext()
        return watchlist
    }
    
    func addSymbolToList(symbol: String) {
        guard let currentWatchlist = currentWatchlist else { return }
        // update in memory
        guard let index = updatedWatchlists.firstIndex(of: currentWatchlist) else { return }
        updatedWatchlists[index].symbols?.insert(symbol)
        self.currentWatchlist = updatedWatchlists[index]
        // update locally
        self.currentWatchlist?.lastUpdatedAt = Date()
        delegate.saveContext()
    }
    
    func removeSymbolToList(symbol: String) {
        guard let currentWatchlist = currentWatchlist else { return }
        // update in memory
        guard let index = updatedWatchlists.firstIndex(of: currentWatchlist) else { return }
        updatedWatchlists[index].symbols?.remove(symbol)
        self.currentWatchlist = updatedWatchlists[index]
        // update locally
        self.currentWatchlist?.lastUpdatedAt = Date()
        delegate.saveContext()
    }
    
    func deleteWatchlist(_ watchlist: Watchlist) {
        guard let index = updatedWatchlists.firstIndex(of: watchlist) else { return }
        // in memory update
        updatedWatchlists.remove(at: index)
        if currentWatchlist == watchlist {
            currentWatchlist = updatedWatchlists.first
        }
        // local storage update
        self.context.delete(watchlist)
        delegate.saveContext()
    }
    
    func getLocalUpdatedWatchlists(completion: ([Watchlist]) -> Void) {
        if delegate.isFirstLaunch, let defaultWatchlist = initializeDefaultWatchlist {
            completion([defaultWatchlist])
        } else {
            do {
                completion(try context.fetch(Watchlist.fetchRequest()))
                return
            } catch { print("get watch lists locally error") }
            completion([])
        }
    }
}
