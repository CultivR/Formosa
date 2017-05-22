//
//  Reason.swift
//  Emissary
//
//  Created by Jordan Kay on 9/17/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

public enum Reason: Error {
    case invalidBaseURL
    case noData
    case couldNotProcessData(Data, Error?)
    case couldNotParseData(Any, Error?)
    case noSuccessStatusCode(NSHTTPURLResponse.StatusCode, Any)
    case connectivity(Data?, Error?)
    
    public static var connectivityNotificationName: Notification.Name {
        return Notification.Name("ReasonConnectivityNotification")
    }
    
    public func checkConnectivity() {
        switch self {
        case .connectivity:
            let notification = Reason.connectivityNotificationName
            return NotificationCenter.default.post(name: notification, object: nil)
        default:
            return
        }
    }
}
