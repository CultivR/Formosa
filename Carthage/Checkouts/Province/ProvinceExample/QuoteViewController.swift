//
//  QuoteViewController.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa
import Province

final class QuoteViewController: UIViewController, ItemDisplaying {
    typealias Item = Quote
    typealias View = QuoteView
    
    func canSelectItem(_ quote: Quote) -> Bool {
        return false
    }
}
