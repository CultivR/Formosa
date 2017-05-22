//
//  Task.swift
//  Emissary
//
//  Created by Jordan Kay on 10/4/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

typealias Process = (Data) throws -> Any
typealias Handler = (Data?, URLResponse?, Error?) -> Void

private let httpVersion = "HTTP/1.1"
private let timeoutInterval: TimeInterval = 10
private let cacheControlHeaderKey = "Cache-Control"
private let delegate = SessionDelegate()

private var urlSession: URLSession = {
    URLCache.shared.memoryCapacity = 0
    URLCache.shared.diskCapacity = 0
    
    let configuration = URLSessionConfiguration.ephemeral
    configuration.urlCache = nil
    configuration.urlCredentialStorage = nil
    configuration.timeoutIntervalForRequest = timeoutInterval
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return URLSession(configuration: configuration, delegate: delegate, delegateQueue: OperationQueue.main)
}()

private class SessionDelegate: NSObject, URLSessionDownloadDelegate {
    var handlers: [URLSessionDownloadTask: Handler] = [:]
    private let handlerQueue = DispatchQueue(label: "handlerQueue")

    // MARK: NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask task: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let response = task.response
        let data = try! Data(contentsOf: location)
        try! FileManager.default.removeItem(at: location)
        
        handlerQueue.async {
            self.handlers[task]?(data, response, nil)
            self.handlers[task] = nil
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        stopIndicatingNetworkActivity()
        handlerQueue.async {
            if let task = task as? URLSessionDownloadTask, error != nil {
                let response = task.response
                self.handlers[task]?(nil, response, error)
                self.handlers[task] = nil
            }
        }
    }
}

func dataTask<T>(withRequest request: URLRequest, resource: Resource<T>?, process: @escaping Process, fulfill: @escaping (T) -> Void, reject: @escaping (Reason) -> Void) -> URLSessionDownloadTask {
    startIndicatingNetworkActivity()
    let task = urlSession.downloadTask(with: request)
    delegate.handlers[task] = { data, response, error in
        autoreleasepool {
            do {
                let processedData = try analyze(data: data, response: response, error: error, process: process)
                let result = try parse(data: processedData, resource: resource)
                DispatchQueue.main.async {
                    fulfill(result)
                }
            } catch {
                DispatchQueue.main.async {
                    reject(error as! Reason)
                }
            }            
        }
    }
    return task
}

private func analyze(data: Data?, response: URLResponse?, error: Error?, process: Process) throws -> Any {
    guard let response = response as? HTTPURLResponse, let statusCode = response.representedStatusCode else {
        throw Reason.connectivity(data, error)
    }
    guard let data = data else {
        throw Reason.noData
    }
    guard statusCode.category != .serverError else {
        throw Reason.noSuccessStatusCode(statusCode, data)
    }
    
    let result: Any
    do {
        result = try process(data)
    } catch let error {
        throw Reason.couldNotProcessData(data, error)
    }
    guard statusCode.category == .success else {
        throw Reason.noSuccessStatusCode(statusCode, result)
    }
    return result
}

private func parse<T>(data: Any, resource: Resource<T>?) throws -> T {
    do {
        guard let result = try resource?.parse(data) ?? data as? T else {
            throw Reason.couldNotParseData(data, nil)
        }
        return result
    } catch {
        throw Reason.couldNotParseData(data, error)
    }
}
