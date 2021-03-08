//
//  WatchlistViewController.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import UIKit
import Combine

class WatchlistViewController: UIViewController {
    
    private let mainView = WatchlistMainView()
    private let viewModel: WatchlistViewModel
    private var cancellableBag = Set<AnyCancellable>()
    
    private var detailVC: SymbolDetailViewConntroller?
    
    private lazy var navTitleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        button.backgroundColor = .clear
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 1
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(showMoreLists), for: .touchUpInside)
        return button
    }()
    
    enum Section: Int, CaseIterable {
        case main = 0
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MarketBatch>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MarketBatch>
    private lazy var dataSource = makeDataSource()
    
    init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        setupNavbar()
        
        self.mainView.collectionView.delegate = self
        mainView.collectionView.register(WatchlistCellView.self, forCellWithReuseIdentifier: WatchlistCellView.reuseIdentifier)
        mainView.collectionView.register(WatchlistMainSectionHeaderView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: WatchlistMainSectionHeaderView.reuseIdentifier)
        setupQuotesObservable()
        setupCurrentListObservable()
        setupTimerSubscribers()
        applySnapshot()
        viewModel.updateBatch()
    }
    
}

// MARK: - UICollectionViewDelegate
extension WatchlistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let quote = self.dataSource.itemIdentifier(for: indexPath) else { return }
        let viewModel = SymbolDetailViewModel(batch: quote)
        self.detailVC = SymbolDetailViewConntroller(viewModel: viewModel)
        self.detailVC?.modalPresentationStyle = .custom
        self.detailVC?.transitioningDelegate = self
        self.present(self.detailVC!, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension WatchlistViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: Data Source
extension WatchlistViewController {
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: mainView.collectionView, cellProvider: getCell(collection:indexPath:item:))
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: WatchlistMainSectionHeaderView.reuseIdentifier,
                                                                       for: indexPath) as? WatchlistMainSectionHeaderView
            return view
        }
        
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = false) {
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(self.viewModel.batches)
        self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
    }
    
    func getCell(collection: UICollectionView, indexPath: IndexPath, item: MarketBatch?) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .main:
            guard let cell: WatchlistCellView = collection.dequeueReusableCell(withReuseIdentifier: WatchlistCellView.reuseIdentifier, for: indexPath) as? WatchlistCellView else { fatalError("wrong cell type") }
            cell.quote = item
            cell.onDeletion = { [weak self] (quote, indexPath) in
                guard let self = self else { return }
                self.viewModel.updateWatchlists(with: .remove(symbol: quote.symbol.symbol))
            }
            return cell
        case .none:
            fatalError("incorrect section with no cell type")
        }
    }
    
}

// MARK: - Combine
private extension WatchlistViewController {
    func setupQuotesObservable() {
        self.viewModel.$batches.receive(on: DispatchQueue.main)
            .sink { [weak self] quotes in
                guard let self = self else { return }
                self.applySnapshot()
                guard let detailVC = self.detailVC else { return }
                guard let quote = quotes.filter({ (batch) in
                    batch.quote.symbol == detailVC.viewModel.quote.symbol
                }).first?.quote else { return }
                detailVC.viewModel.quote = quote
            }.store(in: &cancellableBag)
    }
    
    func setupCurrentListObservable() {
        self.viewModel.$currentWatchlist.receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] watchlist in
                // when user selected new currentWatchlist through nav bar, update quotes through api
                guard let self = self else { return }
                guard let name = watchlist?.name else {
                    /// update collection view with empty state view
                    return
                }
                self.navTitleButton.setTitle("\(name) ▼", for: .normal)
                self.viewModel.getNewestQuotes(type: .all)
            }.store(in: &cancellableBag)
    }
    
    func setupTimerSubscribers() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] notification in
                guard let self = self else { return }
                self.viewModel.updateBatch()
            }
            .store(in: &cancellableBag)
        
        NotificationCenter.default
            .publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] notification in
                guard let self = self else { return }
                self.viewModel.timer?.cancel()
                self.viewModel.timer = nil
            }
            .store(in: &cancellableBag)
    }
}

// MARK: - Nav bar
private extension WatchlistViewController {
    func setupNavbar() {
        let plusItem = UIBarButtonItem(image: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(addNewSymbol))
        self.navigationItem.rightBarButtonItem = plusItem
        navigationItem.titleView = navTitleButton
        let deleteItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteList))
        self.navigationItem.leftBarButtonItem = deleteItem
    }
    
    @objc func addNewSymbol() {
        let search = SymbolSearchViewController(api: ServiceApi.shared.symbol, currentWatchlist: self.viewModel.currentWatchlist?.symbols ?? Set<String>())
        search.onSymbolFollowed = { [weak self] symbol in
            guard let self = self else { return }
            self.viewModel.updateWatchlists(with: .add(symbol: symbol.symbol))
        }
        let nav = UINavigationController(rootViewController: search)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func showMoreLists() {
        presentListActionSheet()
    }
    
    @objc func deleteList() {
        confirmDeleteList()
    }
}

// MARK: - Alerts
private extension WatchlistViewController {
    
    func presentListActionSheet() {
        let sheet = UIAlertController(title: "Watchlists", message: nil, preferredStyle: .actionSheet)
        var items = [UIAlertAction]()
        self.viewModel.updatedWatchlists.forEach { list in
            let action = UIAlertAction(title: list.name ?? "Name Not Found", style: .default) { [weak self] _ in
                guard let self = self else { return }
                // adjust currentList
                self.viewModel.currentWatchlist = list
            }
            items.append(action)
        }
        let addListAction = UIAlertAction(title: "Add a Watchlist", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.presentAddListAlert()
        }
        items.append(addListAction)
        items.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        items.forEach { sheet.addAction($0) }
        self.present(sheet, animated: true, completion: nil)
    }
    
    func presentAddListAlert() {
        let alert = UIAlertController(title: "Add a Watchlist", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "input watchlist name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self, let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self.viewModel.updateWatchlists(with: .create(name: text))
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmDeleteList() {
        let alert = UIAlertController(title: "Delete this Watchlist?", message: "Once you deleted this list, all its symbol will be gone. Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self = self, let currentList = self.viewModel.currentWatchlist else { return }
            self.viewModel.updateWatchlists(with: .delete(watchlist: currentList))
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
