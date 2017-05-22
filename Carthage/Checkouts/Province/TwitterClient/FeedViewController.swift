//
//  FeedViewController.swift
//  Province
//
//  Created by Jordan Kay on 5/18/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Klaxon
import Mensa
import Province
import Then

class FeedViewController<FeedType: Feed & DataSource>: UIViewController, Stateful where FeedType.ErrorType: KlaxonError {
    lazy var state: FeedViewControllerState<FeedType> = .init(feed: self.feed, delegate: self)
    
    fileprivate var feed: FeedType
    
    fileprivate lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    init(feed: FeedType) {
        self.feed = feed
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(feed: FeedType, coder: NSCoder) {
        self.feed = feed
        super.init(coder: coder)
    }
    
    func handleRefresh() {
        guard let newest = feed.data.first else { return }
        state.loadNewerData(count: .defaultCount, since: newest)
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplayContext()
        
        tableView?.isScrollEnabled = false
        tableView?.refreshControl = refreshControl
        
        state.loadInitialData(count: .defaultCount)
    }
    
    // MARK: NSCoding
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension FeedViewController: DataDisplaying {
    typealias Item = FeedType.Item
    typealias View = UIView
    
    var dataSource: FeedType {
        return feed
    }
    
    var displayContext: DataDisplayContext {
        return .tableView(separatorInset: 0, separatorPlacement: .allCells)
    }
    
    func use(_ view: UIView, with item: FeedType.Item, variant: DisplayVariant, displayed: Bool) {
        if view is LoadingIndicatorView, let oldest = feed.data.last, displayed {
            state.loadOlderData(count: .defaultCount, before: oldest)
        }
    }
}

extension FeedViewController: FeedViewControllerStateDelegate {
    func state<T: Feed>(_ state: FeedViewControllerState<T>, didUpdate feedLoadingState: FeedLoadingState<T>) {
        refreshControl.endRefreshing()
        switch feedLoadingState {
        case let .loaded(data, position):
            let data = data.map { $0 as! FeedType.Data }
            insert(data, at: position)
        case let .failedToLoad(error):
            let error = error as! FeedType.ErrorType
            UIAlertController.showError(error)
        default:
            break
        }
    }
}

private extension FeedViewController {
    func insert(_ data: [FeedType.Data], at position: FeedPosition?) {
        let rows: CountableRange<Int>
        let count = data.count
        let existingCount = feed.data.count
        switch position {
        case .top?:
            rows = 0..<count
            feed.data = data + feed.data
        case .bottom?, nil:
            rows = existingCount..<existingCount + count
            feed.data = feed.data + data
        }
        
        let indexPaths = rows.map { IndexPath(row: $0, section: 0) }
        insertItems(at: indexPaths)
        dataView.isScrollEnabled = true
    }
}

private extension Int {
    static let defaultCount = 25
}
