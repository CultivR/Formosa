//
//  SignUpForm.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Formosa
import Province
import SwiftTask

struct SignUpForm: AuthenticationForm {
    typealias SubmissionError = ExampleError
    
    var input: [AuthenticationFormField: String] = [:]
    
    static var formFields: [AuthenticationFormField] {
        return [.fullName, .username, .password, .email]
    }
    
    static var name: String {
        return Strings.signUpLabel.localized
    }
    
    static var prompt: String {
        return Strings.signUpPrompt.localized
    }
    
    static var submitAction: AuthenticationFormAction {
        return .signUp
    }
    
    func submit() -> SubmitTask {
        return Task { [credentials] _, fulfill, reject, _ in
            ExampleSession.current.signUp(credentials: credentials) { state in
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
