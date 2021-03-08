//
//  Quote.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

struct Quote: Decodable {
    let symbol: Symbol
    let latestPrice: Double
    // holiday, weekend will be null
    let bidPrice: Double?
    // holiday, weekend will be null
    let askPrice: Double?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try Symbol(from: decoder)
        latestPrice = try container.decode(Double.self, forKey: .latestPrice)
        bidPrice = try container.decodeIfPresent(Double.self, forKey: .bidPrice)
        askPrice = try container.decodeIfPresent(Double.self, forKey: .askPrice)
    }
    
    var bidDetail: String {
        "Bid Price: " + "\(bidPrice?.in2Decimal ?? "N/A")"
    }
    
    var latestDetail: String {
        "Latest Price: " + latestPrice.in2Decimal
    }
    
    var askDetail: String {
        "Ask Price: " + "\(askPrice?.in2Decimal ?? "N/A")"
    }
}

extension Quote: Equatable, Hashable {}
extension Quote: Comparable {
    static func < (lhs: Quote, rhs: Quote) -> Bool {
        lhs.symbol.symbol < rhs.symbol.symbol
    }
}

private extension Quote {
    enum CodingKeys: String, CodingKey {
        case companyName
        case latestPrice
        case bidPrice = "iexBidPrice"
        case askPrice = "iexAskPrice"
    }
}
