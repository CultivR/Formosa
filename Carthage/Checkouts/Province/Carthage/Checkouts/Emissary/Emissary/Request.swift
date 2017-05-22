//
//  Request.swift
//  Emissary
//
//  Created by Jordan Kay on 9/17/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

extension URLRequest {
    init<T>(baseURL: URL, resource: Resource<T>, pathUsesTrailingSlash: Bool, additionalHeaders: [Header]) {
        let url = baseURL.appendingPathComponent(resource.path.string(trailingSlash: pathUsesTrailingSlash))
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = resource.queryItems

        self.init(url: components.url!)
        
        httpMethod = resource.method.rawValue
        httpBody = resource.requestBody
        
        let headers = (resource.headers ?? []) + additionalHeaders
        for header in headers {
            let value = header.value.description
            let field = header.field.description
            setValue(value, forHTTPHeaderField: field)
        }
    }
}
