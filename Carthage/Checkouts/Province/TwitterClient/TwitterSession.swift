//
//  TwitterSession.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Accounts
import Province
import SwiftTask

typealias TwitterAPITask = Task<Float, TwitterAPI, TwitterError>

final class TwitterSession {
    var authenticationState: AuthenticationState<TwitterAPI, TwitterError> = .loggedOut
    var runningLogInTask: TwitterAPITask?
    var runningLogOutTask: BasicTask?
    var runningRestoreLoginTask: TwitterAPITask?
    
    weak var delegate: SessionDelegate?
    
    init(delegate: SessionDelegate) {
        self.delegate = delegate
    }
}

extension TwitterSession: Session {    
    static let current = TwitterSession(delegate: UIApplication.shared)
    
    static var logOutTask: BasicTask {
        return Task(value: ())
    }
    
    static func logInTask(username: String? = nil, password: String? = nil) -> TwitterAPITask {
        return Task { progress, fulfill, reject, configure in
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
            accountStore.requestAccessToAccounts(with: accountType, options: nil) { success, error in
                if success {
                    guard let account = accountStore.accounts(with: accountType).last as? ACAccount else {
                        reject(.noAccounts)
                        return
                    }
                    let api = TwitterAPI(account: account)
                    fulfill(api)
                } else {
                    reject(.accountAccessFailed)
                }
            }
        }
    }
    
    static var restoreLoginTask: TwitterAPITask {
        return logInTask()
    }
}
