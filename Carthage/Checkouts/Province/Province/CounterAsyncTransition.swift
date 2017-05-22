//
//  CounterAsyncTransition.swift
//  Province
//
//  Created by Jordan Kay on 5/15/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

public enum CounterAsyncTransition {
    case increment(optimistic: Bool)
    case decrement(optimistic: Bool)
}
