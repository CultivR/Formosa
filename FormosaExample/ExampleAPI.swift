//
//  ExampleAPI.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Province
import SwiftTask

typealias BasicTask = Task<Float, Void, ExampleError>
typealias ExampleAPITask = Task<Float, ExampleAPI, ExampleError>

struct ExampleAPI {    
    let account: ExampleAccount?
    
    init(account: ExampleAccount? = nil) {
        self.account = account
    }
}
