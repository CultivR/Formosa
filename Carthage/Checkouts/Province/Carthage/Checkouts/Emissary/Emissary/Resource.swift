//
//  Resource.swift
//  Emissary
//
//  Created by Jordan Kay on 9/17/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

import Decodable

public struct Resource<T> {
    let path: Path
    let queryItems: [URLQueryItem]?
    let requestBody: Data?
    let headers: [Header]?
    let method: Method
    let parse: (Any) throws -> T
    
    public init(path: Path, queryParameters: [(String, String)]? = nil, data: FormData? = nil, method: Method, parse: @escaping (Any) throws -> T) {
        self.path = path
        self.method = method
        self.parse = parse
        
        requestBody = data?.requestBody
        headers = data?.headers
        queryItems = queryParameters?.map { name, value in
            URLQueryItem(name: name, value: value)
        }
    }
}

extension Resource where T: Decodable {
    public init(path: Path, queryParameters: [(String, String)]? = nil, data: FormData? = nil, method: Method) {
        self.init(path: path, queryParameters: queryParameters, data: data, method: method, parse: T.decode)
    }
}

extension Resource where T: Collection, T.Iterator.Element: Decodable {
    public init(path: Path, queryParameters: [(String, String)]? = nil, data: FormData? = nil, method: Method) {
        self.init(path: path, queryParameters: queryParameters, data: data, method: method) { data in
            guard let
                array = data as? [Any],
                let result = try (array.map { try T.Iterator.Element.decode($0) } as? T) else {
                throw Reason.couldNotParseData(data, nil)
            }
            return result
        }
    }
}

