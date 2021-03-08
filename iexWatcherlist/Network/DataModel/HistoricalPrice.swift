//
//  HistoricalPrice.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/5/21.
//

import Foundation
import Charts

struct HistoricalPrice: Decodable {
    let high: Double
    let low: Double
    let symbolString: String
    let date: Date
    let chartData: ChartDataEntry
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        high = try container.decode(Double.self, forKey: .high)
        low = try container.decode(Double.self, forKey: .low)
        symbolString = try container.decode(String.self, forKey: .symbolString)
        let dateString = try container.decode(String.self, forKey: .date)
        date = DateFormat.historyPrice.formatter.date(from: dateString)!
        chartData = ChartDataEntry(x: date.timeIntervalSince1970, y: (high + low) / 2)
    }
    
}

extension HistoricalPrice: Equatable, Hashable {}

private extension HistoricalPrice {
    enum CodingKeys: String, CodingKey {
        case high
        case low
        case symbolString = "symbol"
        case date
    }
}
