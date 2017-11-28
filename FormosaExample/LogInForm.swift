//
//  LogInForm.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Formosa
import SwiftTask

struct LogInForm: AuthenticationForm {
    typealias SubmissionError = ExampleError
    
    var input: [AuthenticationFormField: String] = [:]
    
    static var name: String {
        return Strings.logInLabel.localized
    }
    
    static var prompt: String {
        return Strings.logInPrompt.localized
    }

    static var submitAction: AuthenticationFormAction {
        return .logIn
    }
    
    static var formFields: [AuthenticationFormField] {
        return [.username, .password]
    }
    
    func submit() -> SubmitTask {
        return Task { [credentials] _, fulfill, reject, _ in
            ExampleSession.current.logIn(credentials: credentials) { state in
                switch state {
                case .loggedIn:
                    fulfill(())
                case let .failedToLogIn(error):
                    reject(error)
                default:
                    break
                }
            }
        }
    }
    
    func cancelSubmission() {}
}
