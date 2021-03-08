//
//  SymbolDetailViewModel.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation

class SymbolDetailViewModel {
    
    @Published
    var quote: Quote
    let historyPrices: [HistoricalPrice]
    
    init(batch: MarketBatch) {
        self.quote = batch.quote
        self.historyPrices = batch.historyPrices
    }
}
