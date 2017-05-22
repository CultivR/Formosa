//
//  Stateful.swift
//  Province
//
//  Created by Jordan Kay on 5/14/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

public protocol Stateful {
    associatedtype StateHolderType: StateHolder
    
    var state: StateHolderType { get }
}
