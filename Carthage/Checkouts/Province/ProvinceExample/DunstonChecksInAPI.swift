//
//  DunstonChecksInAPI.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Emissary

struct DunstonChecksInAPI: API {
    static var baseURL: URL! {
        return URL(string: "https://www.wonder-tonic.com/dunstonapi/json")
    }
    
    static var pathsUseTrailingSlash: Bool {
        return true
    }
}
