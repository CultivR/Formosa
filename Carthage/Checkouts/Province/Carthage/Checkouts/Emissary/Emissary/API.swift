//
//  API.swift
//  Emissary
//
//  Created by Jordan Kay on 10/22/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

import SwiftTask

public typealias BasicTask = Task<Float, Void, Reason>

public enum ResponseFormat {
    case json
    case xml
}

public protocol API {
    static var baseURL: URL! { get }
    static var pathsUseTrailingSlash: Bool { get }
    static var responseFormat: ResponseFormat { get }

    var urlSession: URLSession? { get }
    var authToken: AuthToken? { get }
    var authorizationHeader: Header? { get }
    
    func request<T>(_ resource: Resource<T>) -> Task<Float, T, Reason>
}

public extension API {
    static var responseFormat: ResponseFormat { return .json }
    static var pathsUseTrailingSlash: Bool { return false }

    var urlSession: URLSession? { return nil }
    var authToken: AuthToken? { return nil }
    var authorizationHeader: Header? { return nil }
    
    public func request<T>(_ resource: Resource<T>) -> Task<Float, T, Reason> {
        return Task { progress, fulfill, reject, configure in
            guard let baseURL = type(of: self).baseURL else {
                reject(.invalidBaseURL)
                return
            }
            
            let headers = self.authorizationHeader.map { [$0] } ?? []
            let request = URLRequest(baseURL: baseURL, resource: resource, pathUsesTrailingSlash: type(of: self).pathsUseTrailingSlash, additionalHeaders: headers)
            if let url = request.url {
                print(url)
            }
            
            let task = dataTask(withRequest: request, resource: resource, process: type(of: self).processData, fulfill: fulfill, reject: reject)
            task.resume()
        }
    }
    
    private static func processData(data: Data) throws -> Any {
        switch responseFormat {
        case .json:
            if data.count == 0 {
                return [:]
            }
            return try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        case .xml:
            return 0
        }
    }
}

public extension Task where Progress == Float, Value == Void, Error == Reason {
    static var noop: BasicTask {
        return Task(value: ())
    }
}
