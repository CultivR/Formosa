//
//  Response.swift
//  Emissary
//
//  Created by Jordan Kay on 12/4/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

public extension HTTPURLResponse {
    public enum StatusCode: Int {
        enum Category: Int {
            case informational = 1
            case success = 2
            case redirection = 3
            case clientError = 4
            case serverError = 5
        }
        
        case `continue` = 100
        case switchingProtocols = 101
        case processing = 102

        case ok = 200
        case created = 201
        case accepted = 202
        case nonAuthoritativeInformation = 203
        case noContent = 204
        case resetContent = 205
        case partialContent = 206
        case multiStatus = 207
        case alreadyReported = 208
        case imUsed = 226
        
        case multipleChoices = 300
        case movedPermanently = 301
        case found = 302
        case seeOther = 303
        case notModified = 304
        case useProxy = 305
        case switchProxy = 306
        case temporaryRedirect = 307
        case permanentRedirect = 308
        case resumeIncomplete = 309
        
        case badRequest = 400
        case unauthorized = 401
        case paymentRequired = 402
        case forbidden = 403
        case notFound = 404
        case methodNotAllowed = 405
        case notAcceptable = 406
        case proxyAuthenticationRequired = 407
        case requestTimeout = 408
        case conflict = 409
        case gone = 410
        case lengthRequired = 411
        case preconditionFailed = 412
        case payloadTooLarge = 413
        case uriTooLarge = 414
        case unsupportedMediaType = 415
        case rangeNotSatisfiable = 416
        case expectationFailed = 417
        case imATeapot = 418
        case authenticationTimeout = 419
        case enhanceYourCalm = 420
        case misdirectedRequest = 421
        case unprocessableEntity = 422
        case locked = 423
        case failedDependency = 424
        case upgradeRequired = 426
        case preconditionRequired = 428
        case tooManyRequests = 429
        case requestHeaderFieldsTooLarge = 431
        case loginTimeout = 440
        case noResponse = 444
        case retryWith = 449
        case blockedByWindowsParentalControls = 450
        case unavailableForLegalReasons = 451
        case requestHeaderTooLarge = 494
        case certError = 495
        case noCert = 496
        case httpToHTTPS = 497
        case tokenExpiredInvalid = 498
        case clientClosedRequest = 499

        case internalServerError = 500
        case notImplemented = 501
        case badGateway = 502
        case serviceUnavailable = 503
        case gatewayTimeout = 504
        case httpVersionNotSupported = 505
        case variantAlsoNegotiates = 506
        case insufficientStorage = 507
        case loopDetected = 508
        case bandwidthLimitExceeded = 509
        case notExtended = 510
        case networkAuthenticationRequired = 511
        case unknownError = 520
        case originConnectionTimeout = 522
        case networkReadTimeoutError = 598
        case networkConnectTimeoutError = 599
        
        var category: Category? {
            return Category(rawValue: firstDigit)
        }
    }
    
    var representedStatusCode: StatusCode? {
        return StatusCode(rawValue: statusCode)
    }
}

extension HTTPURLResponse.StatusCode: CustomStringConvertible {
    public var description: String {
        return "HTTP \(rawValue)"
    }
}

private extension HTTPURLResponse.StatusCode {
    var firstDigit: Int {
        return rawValue / 100
    }
}
