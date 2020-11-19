//
//  StringViewController.swift
//  Formosa
//
//  Created by Jordan Kay on 5/24/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Mensa

final class StringViewController: UIViewController, ItemDisplaying {
    typealias Item = String
    typealias View = StringView
    
    func itemSizingStrategy(displayedWith variant: DisplayVariant) -> ItemSizingStrategy {
        return ItemSizingStrategy(widthReference: .containerView, heightReference: .constraints)
    }
    
    func canSelectItem(_ string: String) -> Bool {
        return false
    }
}
