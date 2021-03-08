//
//  ApiQuote.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

protocol ApiQuote {
    
    /// get Quote via a symbol
    /// - Parameters:
    ///   - symbol: stock symbol
    ///   - completion: Returns a Quote or error
    func getQuote(with symbol: String, _ completion: @escaping (Result<Quote, ServiceRequestError>) -> Void)
    
    /// get MarketBatch via an array of symbols
    /// - Parameters:
    ///   - symbols: set of stock symbols
    ///   - type: BatchDataType
    ///   - completion: Returns an array of MarketBatch or error
    func getQuotes(with symbols: Set<String>, type: BatchDataType, _ completion: @escaping (Result<[MarketBatch], ServiceRequestError>) -> Void)
}
