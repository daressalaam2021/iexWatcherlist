//
//  SymbolDetailMainView.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation
import UIKit

class SymbolDetailMainView: UIView {
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "detailBackground")
        return image
    }()
    
    private lazy var symbol: UILabel = {
        let label = UILabel()
        label.setupDetail(type: .symbol)
        return label
    }()
    
    private lazy var companyName: UILabel = {
        let label = UILabel()
        label.setupDetail(type: .symbol)
        return label
    }()
    
    private lazy var bidPrice: UILabel = {
        let label = UILabel()
        label.setupDetail(type: .price)
        return label
    }()
    
    private lazy var askPrice: UILabel = {
        let label = UILabel()
        label.setupDetail(type: .price)
        return label
    }()
    
    private lazy var latestPrice: UILabel = {
        let label = UILabel()
        label.setupDetail(type: .price)
        return label
    }()
    
    private lazy var symbolVStack: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [symbol, companyName])
        vstack.axis = .vertical
        vstack.alignment = .center
        vstack.distribution = .fill
        return vstack
    }()
    
    private lazy var priceVStack: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [bidPrice, askPrice, latestPrice])
        vstack.axis = .vertical
        vstack.alignment = .trailing
        vstack.distribution = .fillEqually
        return vstack
    }()
    
    private lazy var overallHStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [symbolVStack, priceVStack])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        return hStack
    }()
    
    lazy var chart: StockHistoryLineChartView = {
        StockHistoryLineChartView()
    }()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }
    
    func updateView(with quote: Quote) {
        self.symbol.text = quote.symbol.symbol
        companyName.text = quote.symbol.companyName
        bidPrice.text = quote.bidDetail
        askPrice.text = quote.askDetail
        latestPrice.text = quote.latestDetail
    }
    
}

private extension SymbolDetailMainView {
    
    func setupSubviews() {
        addSubview(backgroundImage)
        addSubview(overallHStack)
        addSubview(chart)
    }
    
    func setupConstraints() {
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        priceVStack.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        
        overallHStack.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(10)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        chart.snp.makeConstraints {
            $0.top.equalTo(overallHStack.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
}
