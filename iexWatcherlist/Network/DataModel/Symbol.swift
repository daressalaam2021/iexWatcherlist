//
//  Symbol.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

struct Symbol: Decodable {
    let symbol: String
    /// only visible to iex api
    let companyName: String?
    /// only visible to search api
    let description: String?
    
    init(symbol: String, companyName: String?, description: String?) {
        self.symbol = symbol
        self.companyName = companyName
        self.description = description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decode(String.self, forKey: .symbol)
        companyName = try container.decodeIfPresent(String.self, forKey: .companyName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}

extension Symbol: Equatable, Hashable {
    
    static func == (lhs: Symbol, rhs: Symbol) -> Bool {
        lhs.symbol == rhs.symbol
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.symbol)
    }
}

private extension Symbol {
    enum CodingKeys: String, CodingKey {
        case symbol
        case companyName
        case description
    }
}
