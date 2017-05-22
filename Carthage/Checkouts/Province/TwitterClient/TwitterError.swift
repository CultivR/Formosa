//
//  TwitterError.swift
//  Province
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Klaxon

enum TwitterError: Error {
    case noAccounts
    case accountAccessFailed
    case requestFailed(Error?)
}

extension TwitterError: KlaxonError {
    var name: String {
        let string: Strings
        switch self {
        case .noAccounts:
            string = .noAccountsLabel
        case .accountAccessFailed:
            string = .accountAccessFailedLabel
        case .requestFailed:
            string = .requestFailedLabel
        }
        return string.localized
    }
    
    var description: String? {
        switch self {
        case let .requestFailed(error):
            return error.map { String(describing: $0) }
        default:
            return nil
        }
    }
}
