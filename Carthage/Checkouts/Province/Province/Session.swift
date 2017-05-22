//
//  Session.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public protocol Session: StateHolder {
    associatedtype API
    associatedtype ErrorType: Error
    
    typealias APITask = Task<Float, API, ErrorType>
    typealias BasicTask = Task<Float, Void, ErrorType>
    
    var authenticationState: AuthenticationState<API, ErrorType> { get set }
    var runningLogInTask: APITask? { get set }
    var runningLogOutTask: BasicTask? { get set }
    var runningRestoreLoginTask: APITask? { get set }
    
    static var current: Self { get }
    static var logOutTask: BasicTask { get }
    static var restoreLoginTask: APITask { get }
    
    static func logInTask(username: String?, password: String?) -> Task<Float, API, ErrorType>
}

public extension Session {
    var api: APITask {
        cancelTasks()
        if case let .loggedIn(api) = authenticationState {
            return Task(value: api)
        }
        return Task { progress, fulfill, reject, configure in
            self.restoreLogin { state in
                if case let .loggedIn(api) = state {
                    fulfill(api)
                } else if case let .failedToLogIn(error) = state {
                    reject(error)
                }
            }
        }
    }
    
    func logIn(username: String? = nil, password: String? = nil) {
        cancelTasks()
        runningLogInTask = Self.logInTask(username: username, password: password)
        try! authenticationState.transition(with: .logIn, task: runningLogInTask!) { [weak self] in
            self?.authenticationState = $0
        }
    }
    
    func logOut() {
        cancelTasks()
        runningLogOutTask = Self.logOutTask
        try! authenticationState.transition(with: .logOut, task: runningLogOutTask!) { [weak self] in
            self?.authenticationState = $0
        }
    }
    
    func restoreLogin(completion: @escaping (AuthenticationState<API, ErrorType>) -> Void) {
        cancelTasks()
        runningRestoreLoginTask = Self.restoreLoginTask
        try! authenticationState.transition(with: .logIn, task: runningRestoreLoginTask!) { [weak self] in
            self?.authenticationState = $0
            completion($0)
        }
    }
}

private extension Session {
    func cancelTasks() {
        runningLogInTask?.cancel()
        runningLogOutTask?.cancel()
        runningRestoreLoginTask?.cancel()
    }
}

public protocol SessionDelegate: class {}

extension UIApplication: SessionDelegate {}
