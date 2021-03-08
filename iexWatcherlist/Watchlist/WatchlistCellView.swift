//
//  WatchlistCellView.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/3/21.
//

import Foundation
import UIKit

class WatchlistCellView: UICollectionViewCell, ReusableCell {
    
    static let labelWidth = (UIScreen.main.bounds.width - 20) / 4
    
    var onDeletion: ((Quote, IndexPath) -> Void)?
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.setupLabel(type: .symbol)
        return label
    }()
    
    private lazy var bidPriceLabel: UILabel = {
        let label = UILabel()
        label.setupLabel(type: .price)
        return label
    }()
    
    private lazy var askPriceLabel: UILabel = {
        let label = UILabel()
        label.setupLabel(type: .price)
        return label
    }()
    
    private lazy var lastPriceLabel: UILabel = {
        let label = UILabel()
        label.setupLabel(type: .price)
        return label
    }()
    
    private lazy var bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private lazy var deleteLabelR: UILabel = {
        let label = UILabel()
        label.text = "delete"
        label.textColor = .white
        return label
    }()
    
    private lazy var deleteLabelL: UILabel = {
        let label = UILabel()
        label.text = "delete"
        label.textColor = .white
        return label
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        gesture.delegate = self
        return gesture
    }()
    
    var quote: MarketBatch? = nil {
        didSet {
            guard let quote = quote?.quote else { return }
            self.setupCellView(with: quote)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onDeletion = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if panGesture.state == UIGestureRecognizer.State.changed {
            let p: CGPoint = panGesture.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x, y: 0, width: width, height: height);
            self.deleteLabelR.frame = CGRect(x: p.x + width + deleteLabelR.frame.size.width, y: 0, width: 100, height: height)
            self.deleteLabelL.frame = CGRect(x: p.x - deleteLabelL.frame.size.width - 10, y: 0, width: 100, height: height)
        }
    }
}

// MARK: - Subviews
private extension WatchlistCellView {
    func setupSubviews() {
        contentView.addSubview(symbolLabel)
        contentView.addSubview(bidPriceLabel)
        contentView.addSubview(askPriceLabel)
        contentView.addSubview(lastPriceLabel)
        contentView.addSubview(bottomSeparator)
        self.insertSubview(deleteLabelR, belowSubview: self.contentView)
        self.insertSubview(deleteLabelL, belowSubview: self.contentView)
        self.addGestureRecognizer(self.panGesture)
        contentView.backgroundColor = .systemGroupedBackground
    }
    
    func setupConstraints() {
        
        self.symbolLabel.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(10)
            $0.width.equalTo(Self.labelWidth)
            $0.top.bottom.equalTo(contentView)
        }
        
        self.bidPriceLabel.snp.makeConstraints {
            $0.left.equalTo(symbolLabel.snp.right)
            $0.width.equalTo(Self.labelWidth)
            $0.top.bottom.equalTo(contentView)
        }
        
        self.askPriceLabel.snp.makeConstraints {
            $0.width.equalTo(Self.labelWidth)
            $0.top.bottom.equalTo(contentView)
            $0.left.equalTo(bidPriceLabel.snp.right)
        }
        
        self.lastPriceLabel.snp.makeConstraints {
            $0.width.equalTo(Self.labelWidth)
            $0.top.bottom.equalTo(contentView)
            $0.left.equalTo(askPriceLabel.snp.right)
            $0.right.equalTo(self.contentView).inset(10)
        }
        
        self.bottomSeparator.snp.makeConstraints {
            $0.left.right.equalTo(contentView).inset(8)
            $0.height.equalTo(1)
            $0.bottom.equalTo(contentView)
        }
    }
    
    func setupCellView(with quote: Quote) {
        symbolLabel.text = quote.symbol.symbol
        bidPriceLabel.text = quote.bidPrice?.in2Decimal ?? "N/A"
        askPriceLabel.text = quote.askPrice?.in2Decimal ?? "N/A"
        lastPriceLabel.text = quote.latestPrice.in2Decimal
    }
}

extension WatchlistCellView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panGesture.velocity(in: panGesture.view)).x) > abs((panGesture.velocity(in: panGesture.view)).y)
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        guard let quote = quote else { return }
        if pan.state == UIGestureRecognizer.State.began {
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                guard let collectionView = self.superview as? UICollectionView,
                      let indexPath = collectionView.indexPathForItem(at: self.center) else { return }
                self.onDeletion?(quote.quote, indexPath)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
}
