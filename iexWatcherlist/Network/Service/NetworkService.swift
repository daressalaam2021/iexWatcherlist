//
//  NetworkService.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import Foundation

enum ServiceRequestError: Error {
    case unknown
    case urlInvalid
    case client
    case server
    case decoding
}

protocol ServiceProtocol {
    func perform<T>(service request: ServiceRequest, decoding: T.Type, completion: @escaping (Result<T, ServiceRequestError>) -> Void) where T: Decodable
}

extension ServiceProtocol {
    
    func perform<T>(service request: ServiceRequest, decoding: T.Type, completion: @escaping (Result<T, ServiceRequestError>) -> Void) where T: Decodable {
        
        guard let urlRequest = request.urlRequest, let _ = urlRequest.url else {
            completion(.failure(.urlInvalid))
            return
        }
        
        let task = ServiceApi.shared.session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if error != nil || data == nil {
                completion(.failure(.client))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completion(.failure(.server))
                return
            }
            
            do {
                guard let data = data else { return }
                let items = try JSONDecoder().decode(T.self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(.decoding))
            }
        })
        task.resume()
    }
}
