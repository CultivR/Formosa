//
//  SubmissionState.swift
//  Province
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public enum SubmissionState {
    case notYetSubmitted
    case submitting
    case submitted
    case failedToSubmit(Error)
}

extension SubmissionState: State {
    public func transition(with transition: SubmissionTransition, update: @escaping (SubmissionState) -> Void) throws {
        // Cannot submit items synchronously
    }
    
    public func transition<P, V, E: Error>(with transition: SubmissionTransition, task: Task<P, V, E>, update: @escaping (SubmissionState) -> Void) throws {
        switch self {
        case .notYetSubmitted, .failedToSubmit:
            update(.submitting)
            task.then { resource, errorInfo in
                if resource != nil {
                    update(.submitted)
                } else if let error = errorInfo?.error {
                    update(.failedToSubmit(error))
                }
            }
        default:
            throw error(using: transition)
        }
    }
}
