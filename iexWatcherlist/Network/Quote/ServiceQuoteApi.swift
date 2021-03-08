//
//  ServiceQuoteApi.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

final class ServiceQuoteApi: ApiQuote, ServiceProtocol {
    
    private weak var previousQuoteTask: URLSessionTask?
    private weak var previousBatchTask: URLSessionTask?
    
    func getQuote(with symbol: String, _ completion: @escaping (Result<Quote, ServiceRequestError>) -> Void) {
        previousQuoteTask?.cancel()
        let service = Self.getQuote(symbol: symbol)
        
        self.previousQuoteTask = perform(service: service, decoding: Quote.self) { (result) in
            switch result {
            case .success(let quote):
                completion(.success(quote))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getQuotes(with symbols: Set<String>, type: BatchDataType, _ completion: @escaping (Result<[MarketBatch], ServiceRequestError>) -> Void) {
        previousBatchTask?.cancel()
        let service = Self.getQuotes(symbols: symbols, type: type)
        
        self.previousBatchTask = perform(service: service, decoding: [String: MarketBatch].self) { (result) in
            switch result {
            case .success(let batch):
                completion(.success(Array(batch.values)))
                
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
    
    static func getQuotes(symbols: Set<String>, type: BatchDataType) -> ServiceRequest {
        let path = "/stable/stock/market/batch"
        let queryItems: [URLQueryItem]
        if symbols.isEmpty {
            queryItems = []
        } else {
            let symbols = symbols.reduce("", {
                if $0.isEmpty {
                    return $0 + $1
                } else {
                    return $0 + "," + $1
                }
            })
            
            var typeString = ""
            if type.contains(.quote) {
                typeString += "quote"
            }
            if type.contains(.chart) {
                typeString += typeString.isEmpty ? "chart" : ",chart"
            }
            if typeString.isEmpty {
                queryItems = [URLQueryItem(name: "symbols", value: symbols)]
            } else {
                queryItems = [URLQueryItem(name: "symbols", value: symbols),
                              URLQueryItem(name: "types", value: typeString)]
            }
        }
        
        return ServiceRequest(endpoint: Endpoint(path: path, queryItems: queryItems, host: .iex))
    }
}
