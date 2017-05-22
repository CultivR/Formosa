//
//  LoadingState.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public enum LoadingState<Resource> {
    case notYetLoaded
    case loading
    case loaded(Resource)
    case failedToLoad(Error)
}

extension LoadingState: State {
    public func transition(with transition: LoadingTransition, update: @escaping (LoadingState) -> Void) throws {
        // Cannot load resources synchronously
    }
    
    public func transition<P, V, E: Error>(with transition: LoadingTransition, task: Task<P, V, E>, update: @escaping (LoadingState) -> Void) throws {
        switch (self, transition) {
        case (.notYetLoaded, .load), (.loaded, .reload), (.failedToLoad, .reload):
            update(.loading)
            task.then { resource, errorInfo in
                if let resource = resource as? Resource {
                    update(.loaded(resource))
                } else if let error = errorInfo?.error {
                    update(.failedToLoad(error))
                }
            }
        default:
            throw error(using: transition)
        }
    }
}
