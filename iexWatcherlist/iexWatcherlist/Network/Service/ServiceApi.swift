//
//  ServiceApi.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

protocol ServiceApiProtocol {
    var symbol: ApiSymbol { get }
    var quote: ApiQuote { get }
}

final class ServiceApi: ServiceApiProtocol {
    
    let symbol: ApiSymbol
    let quote: ApiQuote
    
    let session: URLSession
    
    static let shared = ServiceApi()
    
    private init() {
        session = URLSession.shared
        symbol = ServiceSymbolApi()
        quote = ServiceQuoteApi()
    }
}

