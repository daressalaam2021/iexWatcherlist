//
//  MarketBatch.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/3/21.
//

import Foundation

struct MarketBatch: Decodable {
    let quote: Quote
    let historyPrices: [HistoricalPrice]
    
    public init(quote: Quote, historyPrices: [HistoricalPrice]) {
        self.quote = quote
        self.historyPrices = historyPrices
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quote = try container.decode(Quote.self, forKey: .quote)
        historyPrices = try container.decodeIfPresent([HistoricalPrice].self, forKey: .chart) ?? []
    }
    
}

extension MarketBatch: Equatable, Hashable {}
extension MarketBatch: Comparable {
    static func < (lhs: MarketBatch, rhs: MarketBatch) -> Bool {
        lhs.quote < rhs.quote
    }
}

private extension MarketBatch {
    enum CodingKeys: String, CodingKey {
        case quote
        case chart
    }
}
