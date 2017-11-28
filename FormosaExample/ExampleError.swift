//
//  ExampleError.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Klaxon

enum ExampleError: Error {
    case failedToLogIn
}

extension ExampleError: KlaxonError {
    var name: String {
        let string: Strings
        switch self {
        case .failedToLogIn:
            string = .failedToLogInTitle
        }
        return string.localized
    }
    
    var description: String? { // TODO: Default
        let string: Strings
        switch self {
        case .failedToLogIn:
            string = .failedToLogInDescription
        }
        return string.localized
    }
}
