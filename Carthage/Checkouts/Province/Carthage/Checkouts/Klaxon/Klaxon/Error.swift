//
//  Error.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

public protocol KlaxonError: Error {
    var name: String { get }
    var description: String? { get }
}

extension KlaxonError {
    var description: String? {
        return nil
    }
}
