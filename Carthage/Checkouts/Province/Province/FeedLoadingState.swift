//
//  FeedloadingState.swift
//  Province
//
//  Created by Jordan Kay on 5/18/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public enum FeedLoadingState<FeedType: Feed> {
    case notYetLoaded
    case loading(FeedPosition?)
    case loaded([FeedType.Data], FeedPosition?)
    case failedToLoad(Error)
}

extension FeedLoadingState: State {
    public func transition(with transition: FeedLoadingTransition, update: @escaping (FeedLoadingState) -> Void) throws {
        // Cannot load feed synchronously
    }
    
    public func transition<P, V, E: Error>(with transition: FeedLoadingTransition, task: Task<P, V, E>, update: @escaping (FeedLoadingState) -> Void) throws {
        switch (self, transition) {
        case let (.notYetLoaded, .load(position)) where position == nil:
            self.performTask(task: task, position: position, update: update)
        case let (_, .load(position)) where position != nil:
            self.performTask(task: task, position: position, update: update)
        default:
            throw error(using: transition)
        }
    }
}

private extension FeedLoadingState {
    func performTask<P, V, E: Error>(task: Task<P, V, E>, position: FeedPosition?, update: @escaping (FeedLoadingState) -> Void) {
        task.then { data, errorInfo in
            if let data = data as? [FeedType.Data] {
                update(.loaded(data, position))
            } else if let error = errorInfo?.error {
                update(.failedToLoad(error))
            }
        }
    }
}
