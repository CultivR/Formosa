//
//  ExampleSession.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Province
import SwiftTask

typealias ExampleAuthenticationState = AuthenticationState<ExampleAPI, ExampleError>

final class ExampleSession {
    var authenticationState: ExampleAuthenticationState = .loggedOut
    
    weak var delegate: SessionDelegate?
    
    init(delegate: SessionDelegate) {
        self.delegate = delegate
    }
}

extension ExampleSession: Session {
    static let current = ExampleSession(delegate: UIApplication.shared)
    
    static var logOutTask: BasicTask {
        return Task(value: ())
    }
    
    static var restoreLoginTask: ExampleAPITask {
        return logInTask()
    }
    
    static func logInTask(credentials: [ExampleCredential: String] = [:]) -> ExampleAPITask {
        let username = credentials[.username]!
        let password = credentials[.password]!
        return ExampleAPI().logIn(username: username, password: password)
    }
    
    static func signUpTask(credentials: [ExampleCredential: String] = [:]) -> ExampleAPITask {
        let fullName = credentials[.fullName]!
        let username = credentials[.username]!
        let password = credentials[.password]!
        let email = credentials[.email]!
        return ExampleAPI().signUp(fullName: fullName, username: username, password: password, email: email)
    }
}
