//
//  AuthToken.swift
//  Emissary
//
//  Created by Jordan Kay on 12/3/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

import Decodable
import SwiftKeychainWrapper

private let accessTokenKey = "access_token"
private let refreshTokenKey = "refresh_token"
private let expirationDurationKey = "expires_in"

public enum AuthTokenError: Error {
    case doesNotExist
    case expired(AuthToken)
}

public struct AuthToken {
    public let accessToken: String
    public let refreshToken: String
    public let expirationDuration: TimeInterval
    fileprivate let creationDate: Date
    
    private var isExpired: Bool {
        let currentDate = Date()
        let expirationDate = creationDate.addingTimeInterval(expirationDuration)
        return currentDate > expirationDate
    }
    
    public static func storeInKeychain(authToken: AuthToken, withIdentifier identifier: String) {
        let data = Data(authToken: authToken)
        KeychainWrapper.standardKeychainAccess().setData(data, forKey: identifier)
    }
    
    public static func removeFromKeychain(withIdentifier identifier: String) {
        KeychainWrapper.standardKeychainAccess().removeObject(forKey: identifier)
    }
    
    public static func retrieveFromKeychain(withIdentifier identifier: String) throws -> AuthToken {
        guard let data = KeychainWrapper.standardKeychainAccess().data(forKey: identifier) else {
            throw AuthTokenError.doesNotExist
        }
        
        let properties = NSKeyedUnarchiver.unarchiveObject(with: data)!
        let token = try! AuthToken.decode(properties)
        guard !token.isExpired else {
            throw AuthTokenError.expired(token)
        }
        
        return token
    }
    
    public func refreshParameters(clientID: String, clientSecret: String) -> [String: String] {
        return [
            "client_id": clientID,
            "client_secret": clientSecret,
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
        ]
    }
    
    public static func parameters(username: String, password: String, clientID: String, clientSecret: String) -> [String: String] {
        return [
            "username": username,
            "password": password,
            "client_id": clientID,
            "client_secret": clientSecret,
            "grant_type": "password"
        ]
    }
}

extension AuthToken: Decodable {
    public static func decode(_ json: Any) throws -> AuthToken {
        let date = (try? json => "creation_date" as! Date) ?? Date()
        return try AuthToken(
            accessToken: json => "access_token",
            refreshToken: json => "refresh_token",
            expirationDuration: json => "expires_in",
            creationDate: date
        )
    }
}

private extension Data {
    init(authToken: AuthToken) {
        let properties: [String: Any] = [
            "access_token": authToken.accessToken,
            "refresh_token": authToken.refreshToken,
            "expires_in": authToken.expirationDuration,
            "creation_date": authToken.creationDate
        ]
        self = NSKeyedArchiver.archivedData(withRootObject: properties)
    }
}
