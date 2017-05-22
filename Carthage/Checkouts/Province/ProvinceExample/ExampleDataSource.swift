//
//  ExampleDataSource.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa

struct ExampleDataSource {
    var quotes: [Quote] = []
}
    
extension ExampleDataSource: DataSource {
    var sections: [Section<Quote>] {
        return [Section(quotes)]
    }
}
