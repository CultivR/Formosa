//
//  ExampleViewControllerState.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Emissary
import Province
import SwiftTask

typealias QuotesLoadingState = LoadingState<[Quote]>

final class ExampleViewControllerState: StateHolder {
    private(set) var quoteCount: Int = .defaultQuoteCount {
        didSet {
            delegate?.state(self, didUpdateQuoteCount: quoteCount)
        }
    }
    
    private(set) var displayStyle: DisplayStyle = .light {
        didSet {
            delegate?.state(self, didUpdate: displayStyle)
        }
    }
    
    private(set) var quotesLoadingState: QuotesLoadingState = .notYetLoaded {
        didSet {
            delegate?.state(self, didUpdate: quotesLoadingState)
        }
    }
    
    weak var delegate: ExampleViewControllerStateDelegate?
    
    init(delegate: ExampleViewControllerStateDelegate) {
        self.delegate = delegate
    }
    
    func updateQuotes(using transition: LoadingTransition) {
        let api = DunstonChecksInAPI()
        let task = api.fetchQuoteList(numberOfQuotes: quoteCount).success { $0.quotes }
        try! quotesLoadingState.transition(with: transition, task: task) { [weak self] in
            self?.quotesLoadingState = $0
        }
    }
    
    func updateQuoteCount(using transition: CounterTransition) {
        try! quoteCount.transition(with: transition) { [weak self] in
            self?.quoteCount = min(max(1, $0), .maxQuoteCount)
        }
    }
    
    func toggleDisplayStyle() {
        try! displayStyle.transition(with: .toggle) { [weak self] in
            self?.displayStyle = $0
        }
    }
}

protocol ExampleViewControllerStateDelegate: class {
    func state(_ state: ExampleViewControllerState, didUpdateQuoteCount quoteCount: Int)
    func state(_ state: ExampleViewControllerState, didUpdate displayStyle: DisplayStyle)
    func state(_ state: ExampleViewControllerState, didUpdate quotesLoadingState: QuotesLoadingState)
}

extension Int {
    static let maxQuoteCount = 10
}

private extension Int {
    static let defaultQuoteCount = 5
}
