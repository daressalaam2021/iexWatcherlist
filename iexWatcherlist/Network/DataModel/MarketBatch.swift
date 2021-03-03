//
//  MarketBatch.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/3/21.
//

import Foundation
#warning("maybe deleted")
struct MarketBatch: Decodable {
    let quotes: Quote
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quotes = try container.decode(Quote.self, forKey: .quote)
    }
    
}

private extension MarketBatch {
    enum CodingKeys: String, CodingKey {
        case quote
    }
}
