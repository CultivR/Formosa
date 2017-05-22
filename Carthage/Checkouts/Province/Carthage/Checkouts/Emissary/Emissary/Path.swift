//
//  Path.swift
//  Emissary
//
//  Created by Jordan Kay on 11/20/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

private let slash = "/"

public struct Path {
    let components: [String]
    
    public init(_ components: String...) {
        self.components = components
    }
    
    fileprivate init(_ components: [String]) {
        self.components = components
    }

    func string(trailingSlash: Bool) -> String {
        var string = components.joined(separator: slash)
        if trailingSlash { string += slash }
        return string
    }
}

public func +(lhs: Path, rhs: Path) -> Path {
    return Path(lhs.components + rhs.components)
}

public func +(lhs: Path, rhs: String) -> Path {
    return Path(lhs.components + [rhs])
}

public func +(lhs: String, rhs: Path) -> Path {
    return Path([lhs] + rhs.components)
}

public func +(lhs: String, rhs: String) -> Path {
    return Path([lhs] + [rhs])
}

public func +=(lhs: inout Path, rhs: Path) {
    return lhs = lhs + rhs
}

public func +=(lhs: inout Path, rhs: String) {
    return lhs = lhs + rhs
}

public protocol PathAccessible {
    static var pathComponent: String { get }
}

public extension PathAccessible {
    static var pathComponent: String {
        return String(describing: self).lowercased()
    }
}
