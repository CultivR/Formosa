//
//  StateHolder.swift
//  Province
//
//  Created by Jordan Kay on 5/14/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public protocol StateHolder: class {
    associatedtype StateHolderDelegateType
    
    var delegate: StateHolderDelegateType? { get }
    init(delegate: StateHolderDelegateType)
}
