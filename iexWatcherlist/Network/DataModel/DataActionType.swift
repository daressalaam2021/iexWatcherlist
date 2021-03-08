//
//  DataActionType.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/3/21.
//

import Foundation

enum DataActionType {
    case create(name: String)
    case add(symbol: String)
    case remove(symbol: String)
    case delete(watchlist: Watchlist)
}
