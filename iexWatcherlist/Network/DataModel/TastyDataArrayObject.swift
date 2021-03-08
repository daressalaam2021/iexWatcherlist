//
//  TastyDataArrayObject.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/6/21.
//

import Foundation

struct TastyDataArrayObject<Element>: Decodable where Element: Decodable {
    
    var items: [Element] = [Element]()
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: DataCodingKeys.self)
        let itemContainer = try dataContainer.nestedContainer(keyedBy: DataCodingKeys.ItemsCodingKeys.self, forKey: .data)
        items = try itemContainer.decode([Element].self, forKey: .items)
    }
    
    private enum DataCodingKeys: String, CodingKey {
        
        case data
        
        enum ItemsCodingKeys: String, CodingKey {
            case items
        }
    }
}
