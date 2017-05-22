//
//  Strings.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

enum Strings: String {
    case cancelLabel
    case okLabel
    
    var localized: String {
        let bundle = Bundle(identifier: "com.squareknot.Klaxon")!
        return NSLocalizedString(rawValue, bundle: bundle, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, locale: Locale.current, arguments: args)
    }
}
