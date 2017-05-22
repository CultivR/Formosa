//
//  Data.swift
//  Emissary
//
//  Created by Jordan Kay on 9/17/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

private let clrf = "\r\n"
private let boundaryLength = 16

public struct FormData {
    let requestBody: Data?
    let headers: [Header]
    
    public init(items: [Any]) throws {
        try self.init(json: items)
    }
    
    public init(parameters: [String: Any]) throws {
        try self.init(json: parameters)
    }
    
    public init(urlEncodedParameters: [String: Any]) {
        headers = [[.contentType: .urlEncoded]]
        
        let string = Array(urlEncodedParameters).map { key, value in
            "\(key)=\(value)"
        }.joined(separator: "&")
        let requestBodyString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        requestBody = requestBodyString.data(using: .utf8)
    }
    
    public init(fieldName: String?, sourceFile: URL?, parameters: [String: String]? = nil) {
        let boundary = String(randomStringOfLength: boundaryLength)
        
        var headers: [Header] = []
        headers.append([.contentType: .multiPartFormData(boundary: boundary)])
        
        requestBody = Data(requestBodyForFile: sourceFile, fieldName: fieldName, parameters: parameters, boundary: "--\(boundary)")
        self.headers = headers
    }
    
    private init(json: Any) throws {
        headers = []
        requestBody = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
}

private extension Data {
    init?(requestBodyForFile file: URL?, fieldName: String?, parameters: [String: String]?, boundary: String) {
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body += boundary
                body += [.contentDisposition: .formData(name: key, filename: nil)]
                body += clrf
                body += value
            }            
        }
        
        if let file = file, let fieldName = fieldName {
            guard let mimeType = file.mimeType else { return nil }
            
            let filename = file.lastPathComponent
            let data = try! Data(contentsOf: URL(fileURLWithPath: file.path))
            body += boundary
            body += [.contentDisposition: .formData(name: fieldName, filename: filename)]
            body += [.contentType: .mimeType(mimeType)]
            body += clrf
            body += data
            body += boundary
        }
        
        self = body
    }
}

private func +=(lhs: inout Data, rhs: Data) {
    lhs.append(rhs)
    lhs += ""
}

private func +=(lhs: inout Data, rhs: String) {
    let string: String = rhs + clrf
    let data = string.data(using: .utf8)!
    lhs.append(data)
}

private func +=(lhs: inout Data, rhs: Header) {
    let data = rhs.description.data(using: .utf8)!
    lhs.append(data)
}

private extension String {
    init(randomStringOfLength length: Int) {
        var length = length
        let uuid = CFUUIDCreate(nil)
        let nonce = CFUUIDCreateString(nil, uuid) as String
        length = min(length, nonce.characters.count)

        let start = nonce.startIndex
        let end = nonce.index(start, offsetBy: length)
        self.init(nonce[start..<end])!
    }
}
