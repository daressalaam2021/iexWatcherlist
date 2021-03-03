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
    let bidPrice: Double
    let askPrice: Double
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try Symbol(from: decoder)
        latestPrice = try container.decode(Double.self, forKey: .latestPrice)
        bidPrice = try container.decode(Double.self, forKey: .bidPrice)
        askPrice = try container.decode(Double.self, forKey: .askPrice)
    }
}

extension Quote: Equatable {}

private extension Quote {
    enum CodingKeys: String, CodingKey {
        case companyName
        case latestPrice
        case bidPrice = "iexBidPrice"
        case askPrice = "iexAskPrice"
    }
}
