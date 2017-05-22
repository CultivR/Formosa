//
//  ToggleAsyncState.swift
//  Province
//
//  Created by Jordan Kay on 5/15/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public enum ToggleAsyncState {
    case on
    case off
    case turningOn
    case turningOff
}

extension ToggleAsyncState: State {
    public func transition(with transition: ToggleAsyncTransition, update: @escaping (ToggleAsyncState) -> Void) throws {
        switch transition {
        case .forceOn:
            update(.on)
        case .forceOff:
            update(.off)
        default:
            throw error(using: transition)            
        }
    }
    
    public func transition<P, V, E: Error>(with transition: ToggleAsyncTransition, task: Task<P, V, E>, update: @escaping (ToggleAsyncState) -> Void) throws {
        var state = self
        switch (self, transition) {
        case (.off, .toggle(let optimistic)), (.on, .toggle(let optimistic)):
            if !optimistic {
                switch self {
                case .on:
                    state = .turningOff
                case .off:
                    state = .turningOn
                default:
                    break
                }
                update(state)
            }
            task.perform(optimistic: optimistic, action: {
                switch state {
                case .on, .turningOff:
                    state = .off
                case .off, .turningOn:
                    state = .on
                }
                update(state)
            }, recovery: {
                switch state {
                case .on, .turningOn:
                    update(.off)
                case .off, .turningOff:
                    update(.on)
                }
            })
        case (.turningOn, .toggle), (.turningOff, .forceOff), (.on, .forceOff):
            update(.off)
        case (.turningOff, .toggle), (.turningOn, .forceOn), (.off, .forceOn):
            update(.on)
        default:
            throw error(using: transition)
        }
    }
}
