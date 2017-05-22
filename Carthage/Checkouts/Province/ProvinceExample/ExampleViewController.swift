//
//  ViewController.swift
//  ProvinceExample
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa
import Province

final class ExampleViewController: UIViewController, Stateful {
    @IBOutlet fileprivate var moreItem: UIBarButtonItem!
    @IBOutlet fileprivate var lessItem: UIBarButtonItem!
    @IBOutlet fileprivate var reloadItem: UIBarButtonItem!
    @IBOutlet fileprivate var displayItem: UIBarButtonItem!
    
    var dataSource = ExampleDataSource()
    lazy var state: ExampleViewControllerState = .init(delegate: self)
    
    @IBAction func reloadQuotes() {
        state.updateQuotes(using: .reload)
    }
    
    @IBAction func incrementQuoteCount() {
        state.updateQuoteCount(using: .increment)
    }

    @IBAction func decrementQuoteCount() {
        state.updateQuoteCount(using: .decrement)
    }
    
    @IBAction func toggleDisplayStyle() {
        state.toggleDisplayStyle()
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplayContext()
        state.updateQuotes(using: .load)
    }
}

extension ExampleViewController: DataDisplaying {
    typealias Item = Quote
    typealias View = QuoteView
    
    var displayContext: DataDisplayContext {
        return .tableView(separatorInset: 0, separatorPlacement: .allCells)
    }
    
    func setupDataView() {
        dataView.backgroundColor = .clear
    }
    
    func variant(for item: Quote, viewType: QuoteView.Type) -> DisplayVariant {
        return QuoteView.Style(displayStyle: state.displayStyle)
    }
}

extension ExampleViewController: ExampleViewControllerStateDelegate {
    func state(_ state: ExampleViewControllerState, didUpdate quotesLoadingState: QuotesLoadingState) {
        switch quotesLoadingState {
        case .notYetLoaded:
            disableControls()
        case .loading:
            if dataSource.quotes.count == 0 {
                title = Strings.loadingLabel.localized
            }
            disableControls()
        case let .loaded(quotes):
            dataSource.quotes = quotes
            title = Strings.quoteCountLabel.localized(quotes.count)
            reloadData()
            enableControls()
        case .failedToLoad:
            title = Strings.failedToLoadLabel.localized
            enableControls()
        }
    }
    
    func state(_ state: ExampleViewControllerState, didUpdateQuoteCount quoteCount: Int) {
        adjustCounterControls()
        reloadQuotes()
    }
    
    func state(_ state: ExampleViewControllerState, didUpdate displayStyle: DisplayStyle) {
        view.backgroundColor = displayStyle.color
        displayItem.title = displayStyle.string
        reloadData()
    }
}

private extension ExampleViewController {
    var controls: [UIBarButtonItem] {
        return [reloadItem, lessItem, moreItem]
    }
    
    func enableControls() {
        reloadItem.isEnabled = true
        adjustCounterControls()
    }
    
    func adjustCounterControls() {
        lessItem.isEnabled = state.quoteCount > 1
        moreItem.isEnabled = state.quoteCount < .maxQuoteCount
    }
    
    func disableControls() {
        controls.forEach { $0.isEnabled = false }
    }
}
