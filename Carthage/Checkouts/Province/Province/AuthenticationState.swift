//
//  AuthenticationState.swift
//  Province
//
//  Created by Jordan Kay on 5/15/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public enum AuthenticationState<API, ErrorType: Error> {
    case loggedOut
    case loggingIn
    case loggedIn(API)
    case loggingOut
    case failedToLogIn(ErrorType)
    case failedToLogOut(ErrorType)
    
    public var isLoggedIn: Bool {
        switch self {
        case .loggedIn, .failedToLogOut:
            return true
        default:
            return false
        }
    }
    
    public var isLoggedOut: Bool {
        switch self {
        case .loggedOut, .failedToLogIn:
            return true
        default:
            return false
        }
    }
}

public enum AuthenticationNotification: String, NotificationName {
    case didLogIn
    case didLogOut
}

extension AuthenticationState: State {
    public func transition(with transition: AuthenticationTransition, update: @escaping (AuthenticationState) -> Void) throws {
        // Transitioning synchronously disallowed
    }
    
    public func transition<P, V, E: Error>(with transition: AuthenticationTransition, task: Task<P, V, E>, update: @escaping (AuthenticationState) -> Void) throws {
        switch (self, transition) {
        case (.loggedOut, .logIn), (.loggedIn, .logOut):
            switch transition {
            case .logIn:
                update(.loggingIn)
                task.then { api, errorInfo in
                    if let api = api as? API {
                        update(.loggedIn(api))
                        AuthenticationNotification.post(.didLogIn, object: self)
                    } else if let error = errorInfo?.error as? ErrorType {
                        update(.failedToLogIn(error))
                    }
                }
            case .logOut:
                update(.loggingOut)
                task.then { value, errorInfo in
                    if let error = errorInfo?.error as? ErrorType {
                        update(.failedToLogOut(error))
                    } else {
                        update(.loggedOut)
                        AuthenticationNotification.post(.didLogOut, object: self)
                    }
                }
            }
        default:
            throw TransitionError(state: self, transition: transition)
        }
    }
}
