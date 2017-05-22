//
//  TwitterAPI.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Accounts
import Social
import SwiftTask

typealias BasicTask = Task<Float, Void, TwitterError>
typealias TweetsTask = Task<Float, [Tweet], TwitterError>

struct TwitterAPI {
    enum Path {
        enum Timeline {
            case home
            case user
        }
        
        case timeline(Timeline)
        case like(Bool)
    }

    fileprivate let account: ACAccount
    
    init(account: ACAccount) {
        self.account = account
    }
}

extension TwitterAPI {
    func task(for path: Path, parameters: [String: String]) -> BasicTask {
        let request = self.request(for: path, parameters: parameters, method: .POST)
        return Task { progress, fulfill, reject, configure in
            request.perform { data, response, error in
                if let data = data {
                    let json = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    guard response?.statusCode == 200 else {
                        let error = try! ErrorList.decode(json).errors.last!
                        DispatchQueue.main.async {
                            reject(.requestFailed(error))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        fulfill()
                    }
                } else {
                    DispatchQueue.main.async {
                        reject(.requestFailed(error))
                    }
                }
            }
        }
    }
    
    func task(for path: Path, parameters: [String: String]) -> TweetsTask {
        let request = self.request(for: path, parameters: parameters, method: .GET)
        return Task { progress, fulfill, reject, configure in
            request.perform { data, response, error in
                if let data = data {
                    let json = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    guard let array = json as? [[String: Any]], response?.statusCode == 200 else {
                        let error = try! ErrorList.decode(json).errors.last!
                        DispatchQueue.main.async {
                            reject(.requestFailed(error))
                        }
                        return
                    }
                    let tweets = try! array.map { try Tweet.decode($0) }
                    DispatchQueue.main.async {
                        fulfill(tweets)
                    }
                } else {
                    DispatchQueue.main.async {
                        reject(.requestFailed(error))
                    }
                }
            }
        }
    }
}

private extension TwitterAPI {
    func request(for path: Path, parameters: [String: String], method: SLRequestMethod) -> SLRequest {
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: method, url: path.url, parameters: parameters)!
        request.account = account
        return request
    }
}

extension TwitterAPI.Path {
    var url: URL? {
        var path: String
        switch self {
        case let .timeline(timeline):
            path = "statuses/"
            switch timeline {
            case .home:
                path += "home"
            case .user:
                path += "user"
            }
            path += "_timeline"
        case let .like(liked):
            path = "favorites/"
            if liked {
                path += "create"
            } else {
                path += "destroy"
            }
        }
        return URL(string: "https://api.twitter.com/1.1/\(path).json")
    }
}

extension Task where Progress == Float, Value == Void, Error == TwitterError {
    static var noop: BasicTask {
        return Task(value: ())
    }
}
