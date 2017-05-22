//
//  CounterAsyncState.swift
//  Province
//
//  Created by Jordan Kay on 5/15/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public enum CounterAsyncState {
    case value(Int)
    case changing(from: Int)
}

extension CounterAsyncState: State {
    public func transition(with transition: CounterAsyncTransition, update: @escaping (CounterAsyncState) -> Void) throws {
        throw error(using: transition)
    }
    
    public func transition<P, V, E: Error>(with transition: CounterAsyncTransition, task: Task<P, V, E>, update: @escaping (CounterAsyncState) -> Void) throws {
        switch (self, transition) {
        case (.value(let value), .increment(let optimistic)), (.value(let value), .decrement(let optimistic)):
            if !optimistic {
                update(.changing(from: value))
            }
            task.perform(optimistic: optimistic, action: {
                switch transition {
                case .increment:
                    update(.value(value + 1))
                case .decrement:
                    update(.value(value - 1))
                }
            }, recovery: { 
                update(.value(value))
            })
        case (.changing(let value), .increment), (.changing(let value), .decrement):
            update(.value(value))
        default:
            throw error(using: transition)
        }
    }
}
