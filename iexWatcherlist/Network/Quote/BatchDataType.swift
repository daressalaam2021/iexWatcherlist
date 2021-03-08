//
//  BatchDataType.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/7/21.
//

import Foundation

struct BatchDataType: OptionSet {
    let rawValue: UInt8
    init(rawValue: UInt8) { self.rawValue = rawValue }
    
    static let quote = BatchDataType(rawValue: 1 << 0)
    static let chart = BatchDataType(rawValue: 1 << 1)
    static let all: BatchDataType = [.chart, .quote]
}
