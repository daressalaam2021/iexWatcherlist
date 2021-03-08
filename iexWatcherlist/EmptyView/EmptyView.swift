//
//  EmptyView.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/6/21.
//

import Foundation
import UIKit

class EmptyView: UIView {
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name:  "AvenirNext-Bold", size: 25)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        backgroundColor = .systemBackground
        emptyLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }
}
