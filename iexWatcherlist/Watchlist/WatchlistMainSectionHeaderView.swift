//
//  WatchlistMainSectionHeaderView.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation
import UIKit

class WatchlistMainSectionHeaderView: UICollectionReusableView, ReusableCell {
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.setupHeader(type: .symbol)
        label.text = "Symbol"
        return label
    }()
    
    private lazy var bidPriceLabel: UILabel = {
        let label = UILabel()
        label.setupHeader(type: .price)
        label.text = "Bid"
        return label
    }()
    
    private lazy var askPriceLabel: UILabel = {
        let label = UILabel()
        label.setupHeader(type: .price)
        label.text = "Ask"
        return label
    }()
    
    private lazy var lastPriceLabel: UILabel = {
        let label = UILabel()
        label.setupHeader(type: .price)
        label.text = "Last"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder) has not been implemented")
    }
    
}

// MARK: - Subviews
private extension WatchlistMainSectionHeaderView {
    func setupSubviews() {
        addSubview(symbolLabel)
        addSubview(bidPriceLabel)
        addSubview(askPriceLabel)
        addSubview(lastPriceLabel)
        backgroundColor = .lightGray
    }
    
    func setupConstraints() {
        
        self.symbolLabel.snp.makeConstraints {
            $0.left.equalTo(self).offset(10)
            $0.width.equalTo(WatchlistCellView.labelWidth)
            $0.top.bottom.equalTo(self)
        }
        
        self.bidPriceLabel.snp.makeConstraints {
            $0.left.equalTo(symbolLabel.snp.right)
            $0.width.equalTo(WatchlistCellView.labelWidth)
            $0.top.bottom.equalTo(self)
        }
        
        self.askPriceLabel.snp.makeConstraints {
            $0.width.equalTo(WatchlistCellView.labelWidth)
            $0.top.bottom.equalTo(self)
            $0.left.equalTo(bidPriceLabel.snp.right)
        }
        
        self.lastPriceLabel.snp.makeConstraints {
            $0.width.equalTo(WatchlistCellView.labelWidth)
            $0.top.bottom.equalTo(self)
            $0.left.equalTo(askPriceLabel.snp.right)
            $0.right.equalTo(self).inset(10)
        }
    }
}
