//
//  ExampleDatabase.swift
//  Formosa
//
//  Created by Jordan Kay on 5/24/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

struct ExampleDatabase {
    static var accounts: [String: String] = [:]
    
    static func addAccount(account: ExampleAccount, withPassword password: String) {
        accounts[account.username] = password
    }
    
    static func accountExists(username: String, password: String) -> Bool {
        return accounts[username] == password
    }
}
