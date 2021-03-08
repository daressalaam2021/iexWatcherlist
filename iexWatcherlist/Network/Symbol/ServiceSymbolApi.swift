//
//  ServiceSymbolApi.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

final class ServiceSymbolApi: ApiSymbol, ServiceProtocol {
    // to make sure when new request made, previous unfinished request will be cancelled
    private weak var previousTask: URLSessionTask?
    
    func getSymbols(with query: String, _ completion: @escaping (Result<[Symbol], ServiceRequestError>) -> Void) {
        self.previousTask?.cancel()
        let service = Self.getSymbols(keyword: query)
        
        self.previousTask = perform(service: service, decoding: TastyDataArrayObject<Symbol>.self) { (result) in
            switch result {
            case .success(let items):
                completion(.success(items.items))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ServiceSymbolApi {
    
    static func getSymbols(keyword: String) -> ServiceRequest {
        let path = "/symbols/search/\(keyword)"
        return ServiceRequest(endpoint: Endpoint(path: path, host: .tastyworks))
    }
}
