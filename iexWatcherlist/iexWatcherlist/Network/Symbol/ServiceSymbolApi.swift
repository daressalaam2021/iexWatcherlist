//
//  ServiceSymbolApi.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

final class ServiceSymbolApi: ApiSymbol {
    
    func getSymbols(with query: String, _ completion: @escaping (Result<[Symbol], ServiceRequestError>) -> Void) {
        /// make service request
    }
    
}
