//
//  Segue.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Perform
import UIKit

extension Segue {
    static var logIn: Segue<UIViewController> {
        return .init(identifier: "LogIn")
    }
    
    static var signUp: Segue<UIViewController> {
        return .init(identifier: "SignUp")
    }
}
