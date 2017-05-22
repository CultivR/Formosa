//
//  LoadingIndicator.swift
//  Province
//
//  Created by Jordan Kay on 5/18/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa

struct LoadingIndicator {}

final class LoadingIndicatorView: UIView, Displayed {
    @IBOutlet private(set) var spinner: UIActivityIndicatorView!
    
    func update(with loadingIndicator: LoadingIndicator, variant: DisplayVariant) {
        spinner.startAnimating()
    }
}

final class LoadingIndicatorViewController: UIViewController, ItemDisplaying {
    typealias Item = LoadingIndicator
    typealias View = LoadingIndicatorView
    
    func canSelectItem(_ loadingIndicator: LoadingIndicator) -> Bool {
        return false
    }
}
