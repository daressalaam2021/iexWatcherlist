//
//  DateFormat.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/5/21.
//

import Foundation

enum DateFormat {
    case historyPrice
    
    var formatter: DateFormatter {
        switch self {
        case .historyPrice:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }
    }
}
