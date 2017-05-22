//
//  ToggleState.swift
//  Province
//
//  Created by Jordan Kay on 5/14/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

extension Bool: State {
    public func transition(with transition: ToggleTransition, update: @escaping (Bool) -> Void) throws {
        update(!self)
    }
    
    public func transition<P, V, E: Error>(with transition: ToggleTransition, task: Task<P, V, E>, update: @escaping (Bool) -> Void) throws {
        throw error(using: transition)
    }
}
