//
//  Hosts.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

enum ApiHost: String {
    case iex = "cloud.iexapis.com"
    case tastyworks = "api.tastyworks.com"
    
    var token: URLQueryItem? {
        switch self {
        case .iex:
            return URLQueryItem(name: "token", value: Self.iexToken())
        case .tastyworks:
            return nil
        }
    }
    
    static func iexToken() -> String {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
              let token = NSDictionary(contentsOfFile: path)?["IEXServerToken"] as? String else {
            fatalError("iex token can't be found")
        }
        return token
    }
}
