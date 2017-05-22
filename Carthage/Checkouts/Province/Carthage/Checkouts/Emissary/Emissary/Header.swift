//
//  Header.swift
//  Emissary
//
//  Created by Jordan Kay on 9/18/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

public struct Header {
    let field: Field
    let value: Value
}

public enum Field {
    case authorization
    case contentType
    case contentDisposition
    case nonStandard(String)
}

public enum Value {
    case apiKey(String)
    case bearer(String)
    case clientID(prefix: String, value: String)
    case mimeType(String)
    case formData(name: String, filename: String?)
    case multiPartFormData(boundary: String)
    case urlEncoded
}

extension Header: CustomStringConvertible {
    public var description: String {
        return "\(field): \(value)"
    }
}

extension Header: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Field, Value)...) {
        (field, value) = elements[0]
    }
}

extension Field: CustomStringConvertible {
    public var description: String {
        switch self {
        case .authorization: return "Authorization"
        case .contentType: return "Content-Type"
        case .contentDisposition: return "Content-Disposition"
        case .nonStandard(let name): return name
        }
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .apiKey(let string):
            return string
        case .bearer(let string):
            return "Bearer " + string
        case .clientID(let prefix, let value):
            return prefix + value
        case .mimeType(let mimeType):
            return mimeType
        case .formData(let name, let filename):
            return description(withKey: "form-data", entries:
                ["name": name],
                filename.map { ["filename": $0] }
            )
        case .multiPartFormData(let boundary):
            return description(withKey: "multipart/form-data", entries:
                ["boundary": boundary]
            )
        case .urlEncoded:
            return "application/x-www-form-urlencoded"
        }
    }
}

private extension Value {
    struct Entry: ExpressibleByDictionaryLiteral {
        let key: String
        let value: String
        
        init(dictionaryLiteral elements: (String, String)...) {
            key = elements[0].0
            value = elements[0].1
        }
    }

    func description(withKey key: String, entries: Entry?...) -> String {
        let strings = entries.flatMap { $0 }.map { "\($0.key)=\"\($0.value)\"" }
        return ([key] + strings).joined(separator: "; ")
    }
}
