//
//  State.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public protocol State {
    associatedtype TransitionType

    // Transition synchronously from current state and update to resulting state
    func transition(with transition: TransitionType, update: @escaping (Self) -> Void) throws
    
    // Transition asynchronously from current state, then update to resulting state
    func transition<P, V, E: Error>(with transition: TransitionType, task: Task<P, V, E>, update: @escaping (Self) -> Void) throws
}

extension State {
    func error(using transition: TransitionType) -> TransitionError<Self> {
        return TransitionError(state: self, transition: transition)
    }
}

struct TransitionError<T: State>: Error {
    private let state: T
    private let transition: T.TransitionType
    
    init(state: T, transition: T.TransitionType) {
        self.state = state
        self.transition = transition
    }
}

extension Task {
    func perform(optimistic: Bool, action: @escaping () -> Void, recovery: @escaping () -> Void) {
        if optimistic {
            action()
        }
        success { _ in
            if !optimistic {
                action()
            }
        }.failure { error, isCancelled in
            if !isCancelled {
                recovery()
            }
        }
    }
}

public protocol NotificationName {}

public extension NotificationName where Self: RawRepresentable, Self.RawValue == String {
    static func post(_ notificationName: Self, object: Any?, userInfo: [AnyHashable: Any]? = nil) {
        let name = Notification.Name(notificationName.rawValue)
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}
