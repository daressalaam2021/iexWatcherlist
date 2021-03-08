//
//  SymbolSearchTableViewCell.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation
import UIKit
import Combine

class FollowedSymbol {
    let symbol: Symbol
    @Published
    var isInCurrentWatchlist: Bool
    
    init(symbol: Symbol, isInCurrentWatchlist: Bool) {
        self.symbol = symbol
        self.isInCurrentWatchlist = isInCurrentWatchlist
    }
}

class SymbolSearchTableViewCell: UITableViewCell, ReusableCell {
    
    private var cancellableBag = Set<AnyCancellable>()
    
    private lazy var symbol: UILabel = {
        let view = UILabel()
        view.setupSearchSymbolLabel(type: .symbol)
        return view
    }()
    
    private lazy var SymbolDescription: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.setupSearchSymbolLabel(type: .description)
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [symbol, SymbolDescription])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var addButton: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var data: FollowedSymbol? {
        didSet {
            guard let data = data else { return }
            self.SymbolDescription.text = data.symbol.description
            self.symbol.text = data.symbol.symbol
            self.updateFollow(data.isInCurrentWatchlist)
            setupRx()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.addButton.image = nil
        cancellableBag = []
    }
    
}

private extension SymbolSearchTableViewCell {
    
    func setupSubviews() {
        contentView.addSubview(vStack)
        contentView.addSubview(addButton)
    }
    
    func setupConstraints() {
        
        addButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalTo(vStack)
            $0.trailing.equalTo(contentView).inset(20)
        }
        
        vStack.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(20)
            $0.top.bottom.equalTo(contentView).inset(7)
            $0.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
    }
    
    func updateFollow(_ follow: Bool) {
        self.addButton.image = follow ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "plus.circle")
        self.isUserInteractionEnabled = follow ? false : true
    }
    
    func setupRx() {
        self.data?.$isInCurrentWatchlist.receive(on: DispatchQueue.main).removeDuplicates()
            .sink { [weak self] follow in
                guard let self = self else { return }
                self.updateFollow(follow)
            }.store(in: &cancellableBag)
    }
}
