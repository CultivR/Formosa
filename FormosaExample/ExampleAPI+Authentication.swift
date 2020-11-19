//
//  ExampleAPI+Authentication.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import SwiftTask
import UIKit

extension ExampleAPI {
    func logIn(username: String, password: String) -> ExampleAPITask {
        return Task { _, fulfill, reject, _ in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            DispatchQueue.global(qos: .background).async {
                sleep(1)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if ExampleDatabase.accountExists(username: username, password: password) {
                        let account = ExampleAccount(username: username)
                        let api = ExampleAPI(account: account)
                        fulfill(api)
                    } else {
                        reject(.failedToLogIn)
                    }
                }
            }
        }
    }
    
    func signUp(fullName: String, username: String, password: String, email: String) -> ExampleAPITask {
        return Task { _, fulfill, reject, _ in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            DispatchQueue.global(qos: .background).async {
                sleep(1)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let account = ExampleAccount(username: username)
                    let api = ExampleAPI(account: account)
                    
                    ExampleDatabase.addAccount(account: account, withPassword: password)
                    fulfill(api)
                }
            }
        }
    }
}
