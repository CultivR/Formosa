//
//  CounterState.swift
//  Province
//
//  Created by Jordan Kay on 5/14/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

extension Int: State {
    public func transition(with transition: CounterTransition, update: @escaping (Int) -> Void) throws {
        switch transition {
        case .increment:
            update(self + 1)
        case .decrement:
            update(self - 1)
        }
    }
    
    public func transition<P, V, E: Error>(with transition: CounterTransition, task: Task<P, V, E>, update: @escaping (Int) -> Void) throws {
        throw error(using: transition)
    }
}
