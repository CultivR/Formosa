//
//  Feed.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public protocol Feed {
    associatedtype Item
    associatedtype Data
    associatedtype ErrorType: Error
    
    typealias LoadDataTask = Task<Float, [Data], ErrorType>
    
    var items: [Item] { get }
    var data: [Data] { get set }
    
    func loadNewerData(count: Int?, since newest: Data?) -> LoadDataTask
    func loadOlderData(count: Int?, before oldest: Data?) -> LoadDataTask
}
