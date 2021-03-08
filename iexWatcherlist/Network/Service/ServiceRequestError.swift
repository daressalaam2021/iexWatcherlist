//
//  ServiceRequestError.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/7/21.
//

import Foundation

enum ServiceRequestError: Error {
    case unknown
    case urlInvalid
    case client
    case server
    case decoding
}
