//
//  DunstonChecksInAPI+Quote.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Emissary
import SwiftTask

typealias QuoteListTask = Task<Float, QuoteList, Reason>

extension DunstonChecksInAPI {
    func fetchQuoteList(numberOfQuotes: Int) -> QuoteListTask {
        return request(Resource(
            path: Path(QuoteList.pathComponent),
            queryParameters: [("num", "\(numberOfQuotes)")],
            method: .get
        ))
    }
}

extension QuoteList: PathAccessible {
    static var pathComponent: String {
        return ""
    }
}

private extension Task where Progress == Float, Value == Void, Error == Reason {
    static var fake: BasicTask {
        return Task { progress, fulfill, reject, configure in
            DispatchQueue.global(qos: .background).async {
                usleep(300000)
                DispatchQueue.main.async {
                    let success = arc4random() % 4 != 0
                    if success {
                        fulfill()
                    } else {
                        reject(.noData)
                    }
                }
            }
        }
    }
}
