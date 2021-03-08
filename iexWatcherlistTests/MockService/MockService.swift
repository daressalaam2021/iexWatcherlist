//
//  MockService.swift
//  iexWatcherlistTests
//
//  Created by Xiang Liu on 3/7/21.
//

import Foundation

class JSONHelper {
    
    static func data(from jsonFile: String) -> Data {
        let filepath = Bundle(for: MockServiceApi.self).path(forResource: jsonFile, ofType: "json")!
        do {
            let contents = try String(contentsOfFile: filepath)
            let data = contents.data(using: .utf8)
            
            if let data = data {
                return data
            }
            
            return Data()
            
        } catch {
            // contents could not be loaded
            return Data()
        }
    }
    
}


final class MockServiceApi: ApiSymbol {
    
    func getSymbols(with query: String, _ completion: @escaping (Result<[Symbol], ServiceRequestError>) -> Void) {
        let items = try? JSONDecoder().decode(TastyDataArrayObject<Symbol>.self, from: JSONHelper.data(from: "symbol"))
        
        if let items = items {
            completion(.success(items.items))
        } else {
            completion(.failure(.decoding))
        }
    }
}

extension MockServiceApi: ApiQuote {
    
    func getQuote(with symbol: String, _ completion: @escaping (Result<Quote, ServiceRequestError>) -> Void) {
        let item = try? JSONDecoder().decode(Quote.self, from: JSONHelper.data(from: "quote"))
        
        if let item = item {
            completion(.success(item))
        } else {
            completion(.failure(.decoding))
        }
    }
    
    func getQuotes(with symbols: Set<String>, type: BatchDataType, _ completion: @escaping (Result<[MarketBatch], ServiceRequestError>) -> Void) {
        let items = try? JSONDecoder().decode([String: MarketBatch].self.self, from: JSONHelper.data(from: "marketBatch"))
        
        if let items = items {
            let batch = Array(items.values).sorted()
            completion(.success(batch))
        } else {
            completion(.failure(.decoding))
        }
    }
}
