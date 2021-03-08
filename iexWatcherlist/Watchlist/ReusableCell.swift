//
//  ReusableCell.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
