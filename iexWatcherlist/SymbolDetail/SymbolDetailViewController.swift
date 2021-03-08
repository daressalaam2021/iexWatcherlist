//
//  SymbolDetailViewController.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/4/21.
//

import Foundation
import UIKit
import Combine

class SymbolDetailViewConntroller: UIViewController {
    
    private let mainView = SymbolDetailMainView()
    private var cancellableBag = Set<AnyCancellable>()
    
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    let viewModel: SymbolDetailViewModel
    
    init(viewModel: SymbolDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        mainView.updateView(with: self.viewModel.quote)
        setupRx()
        mainView.chart.setupData(prices: viewModel.historyPrices)
        mainView.chart.lineChartView.animate(xAxisDuration: 0.03 * Double(viewModel.historyPrices.count))
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    private func setupRx() {
        self.viewModel.$quote.receive(on: DispatchQueue.main).removeDuplicates().sink { [weak self] quote in
            guard let self = self else { return }
            self.mainView.updateView(with: quote)
        }.store(in: &cancellableBag)
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        guard translation.y >= 0 else { return }
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
