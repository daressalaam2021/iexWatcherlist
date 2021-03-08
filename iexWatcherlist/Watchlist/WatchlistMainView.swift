//
//  WatchlistMainView.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/3/21.
//

import Foundation
import UIKit
import SnapKit

class WatchlistMainView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.contentInset = .zero
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupSubviews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder) has not been implemented")
    }
    
}

// MARK: - Subviews
private extension WatchlistMainView {
    func setupSubviews() {
        self.addSubview(self.collectionView)
        self.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}
