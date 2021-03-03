//
//  ServiceQuoteApi.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

final class ServiceQuoteApi: ApiQuote, ServiceProtocol {
    
    func getQuote(with symbol: String, _ completion: @escaping (Result<Quote, ServiceRequestError>) -> Void) {
        let service = Self.getQuote(symbol: symbol)
        
        perform(service: service, decoding: Quote.self) { (result) in
            switch result {
            case .success(let quote):
                completion(.success(quote))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getQuotes(with symbols: [String], _ completion: @escaping (Result<[Quote], ServiceRequestError>) -> Void) {
        let service = Self.getQuotes(symbols: symbols)
        
        perform(service: service, decoding: [String: [String: Quote]].self) { (result) in
            switch result {
            case .success(let quotes):
                // covert dictionary to array
                var quotesArray = [Quote]()
                for (_, value) in quotes {
                    if let quote = value["quote"] {
                        quotesArray.append(quote)
                    }
                }
                completion(.success(quotesArray))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ServiceQuoteApi {
    static func getQuote(symbol: String) -> ServiceRequest {
        let path = "/stable/stock/\(symbol)/quote"
        return ServiceRequest(endpoint: Endpoint(path: path, host: .iex))
    }
    
    static func getQuotes(symbols: [String]) -> ServiceRequest {
        let path = "/stable/stock/market/batch"
        let queryItems: [URLQueryItem]
        if symbols.isEmpty {
            queryItems = []
        } else {
            let symbols = symbols.reduce("", { $0 + "," + $1 })
            queryItems = [URLQueryItem(name: "symbols", value: symbols),
                          URLQueryItem(name: "types", value: "quote")]
        }
        
        return ServiceRequest(endpoint: Endpoint(path: path, queryItems: queryItems, host: .iex))
    }
}
