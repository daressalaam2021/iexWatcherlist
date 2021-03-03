//
//  EndPoint.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

struct Endpoint {
    
    let path: String
    let queryItems: [URLQueryItem]
    let host: ApiHost
    
    init(path: String, queryItems: [URLQueryItem] = [], host: ApiHost) {
        self.path = path
        self.host = host
        if let token = host.token {
            self.queryItems = queryItems + [token]
        } else {
            self.queryItems = queryItems
        }
    }
    
    var url: URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.rawValue
        
        let endPath = path.hasPrefix("/") ? path : "/" + path
        
        components.path = endPath
        
        if queryItems.count > 0 {
            components.queryItems = queryItems
        }
        
        return components.url
        
    }
}
