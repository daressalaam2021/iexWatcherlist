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
    
    /// get Quotes via an array of symbols
    /// - Parameters:
    ///   - symbols: array of stock symbols
    ///   - completion: Returns an array of Quote or error
    func getQuotes(with symbols: [String], _ completion: @escaping (Result<[Quote], ServiceRequestError>) -> Void)
}
