//
//  UILabelExtension.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation
import UIKit

extension UILabel {
    
    enum LabelType {
        case price
        case symbol
        
        var fontName: String {
            switch self {
            case .price:
                return "AvenirNext-Regular"
            case .symbol:
                return "AvenirNext-Bold"
            }
        }
        
        var textAlignment: NSTextAlignment {
            switch self {
            case .price:
                return .right
            case .symbol:
                return .center
            }
        }
    }
    
    enum SearchSymbolType {
        case symbol
        case description
        
        var font: UIFont {
            switch self {
            case .description:
                return UIFont(name: "AvenirNext-Regular", size: 13)!
            case .symbol:
                return UIFont(name: "AvenirNext-Bold", size: 20)!
            }
        }
        
        var color: UIColor {
            switch self {
            case .description:
                return .secondaryLabel
            case .symbol:
                return .label
            }
        }
        
        var numberOfLines: Int {
            switch self {
            case .description:
                return 0
            case .symbol:
                return 1
            }
        }
    }
    
    func setupLabel(type: LabelType) {
        self.font = UIFont(name: type.fontName, size: 12)
        self.textColor = .label
        self.numberOfLines = 1
        self.textAlignment = type.textAlignment
    }
    
    func setupHeader(type: LabelType) {
        self.font = UIFont(name: "AvenirNext-Bold", size: 15)
        self.textColor = .label
        self.numberOfLines = 1
        self.textAlignment = type.textAlignment
    }
    
    func setupDetail(type: LabelType) {
        self.font = UIFont(name: "AvenirNext-Bold", size: 15)
        self.textColor = .white
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.textAlignment = type.textAlignment
    }
    
    func setupSearchSymbolLabel(type: SearchSymbolType) {
        self.font = type.font
        self.textColor = type.color
        self.numberOfLines = type.numberOfLines
        self.textAlignment = .left
    }
    
}
