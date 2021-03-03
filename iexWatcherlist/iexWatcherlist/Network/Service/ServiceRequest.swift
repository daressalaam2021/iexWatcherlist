//
//  ServiceRequest.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

struct ServiceRequest {
    
    let urlRequest: URLRequest?
    
    init(method: HTTPMethod = .get, endpoint: Endpoint, bodyData: Data? = nil) {
        self.urlRequest = Self.request(endpoint: endpoint, method: method, bodyData: bodyData)
    }
}

extension ServiceRequest {
    
    static func request(endpoint: Endpoint, method: HTTPMethod, bodyData: Data?) -> URLRequest? {
        guard let url = endpoint.url else { return nil }
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        if let bodyData = bodyData {
            request.httpBody = bodyData
        }
        
        return request
    }
    
}
