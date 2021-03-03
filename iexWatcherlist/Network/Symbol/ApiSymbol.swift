//
//  ApiSymbol.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

protocol ApiSymbol {
    
    /// get Symbol via query
    /// - Parameters:
    ///   - query: search symbol keywords
    ///   - completion: Returns an array of Symbol or error
    func getSymbols(with query: String, _ completion: @escaping (Result<[Symbol], ServiceRequestError>) -> Void)

}
