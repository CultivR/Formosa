//
//  Image.swift
//  Emissary
//
//  Created by Jordan Kay on 11/8/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

import Cache
import SwiftTask

public typealias ImageTask = Task<Float, UIImage, Reason>

private var imageTaskKey = "imageTask"
private let defaultAnimationDuration = 0.3
private let memoryCache = Cache<String, UIImage>(capacity: 500)
private let diskCache: DiskCache<UIImage> = {
    let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    return DiskCache<UIImage>(directory: documentsPath.path)!
}()

public struct ImageResource<SizeValue: RawRepresentable> {
    public let url: URL
    private let sizeKey: String?
    private let sizeValue: SizeValue?
    
    public init(url: URL, sizeKey: String?, sizeValue: SizeValue?) {
        self.url = url
        self.sizeKey = sizeKey
        self.sizeValue = sizeValue
    }
    
    fileprivate var normalizedURL: URL {
        guard let key = sizeKey, let value = sizeValue?.rawValue else {
            return url
        }
        
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [queryItem]
        return components.url!
    }
}

@discardableResult public func request<T: RawRepresentable>(_ resource: ImageResource<T>) -> ImageTask {
    return Task { progress, fulfill, reject, configure in
        let url = resource.normalizedURL
        
        func process(data: Data) throws -> UIImage {
            guard let image = UIImage(data: data) else {
                throw Reason.couldNotProcessData(data, nil)
            }
            return image
        }
        
        let request = URLRequest(url: url)
        let task = dataTask(withRequest: request, resource: nil, process: process, fulfill: fulfill, reject: reject)
        task.resume()
    }
}

public func cachedImage(forURL url: URL) -> UIImage? {
    let key = url.lastPathComponent
    return memoryCache[key]
}

public func fetchCachedImage(forURL url: URL) -> ImageTask {
    return Task { progress, fulfill, reject, configure in
        let key = url.lastPathComponent
        diskCache.get(key: key) { image in
            DispatchQueue.main.async {
                if let image = image {
                    fulfill(image)
                } else {
                    reject(.noData)
                }
            }
        }
    }
}

public func cacheImage(_ image: UIImage, forURL url: URL, toDisk: Bool) {
    let key = url.lastPathComponent
    memoryCache[key] = image
    if toDisk {
        diskCache.set(key: key, value: image)
    }
}

public protocol ImageDisplaying: class {
    var size: CGSize { get }
    var image: UIImage? { get }
    func setImage(_ image: UIImage?, update: Bool, animated: Bool)
}

extension ImageDisplaying {
    public func setImageURL(_ url: URL, animated: Bool = false) {
        let resource = ImageResource<Size>(url: url, sizeKey: nil, sizeValue: nil)
        setImageURL(url, resource: resource, animated: animated)
    }
    
    public func setImageURL<T: RawRepresentable>(_ url: URL, sizeKey: String, sizeValue: T, animated: Bool = false) {
        let resource = ImageResource(url: url, sizeKey: sizeKey, sizeValue: sizeValue)
        setImageURL(url, resource: resource, animated: animated)
    }
}

extension ImageDisplaying where Self: UIView {
    public var size: CGSize {
        return bounds.size
    }
}

private extension ImageDisplaying {
    func setImageURL<T: RawRepresentable>(_ url: URL, resource: ImageResource<T>, animated: Bool = false) {
        if let existingTask = objc_getAssociatedObject(self, &imageTaskKey) as? ImageTask {
            existingTask.cancel()
        }
        
        if let image = cachedImage(forURL: url) {
            setImage(image, update: true, animated: animated)
        } else {
            setImage(nil, update: true, animated: false)
            fetchCachedImage(forURL: url).success { image in
                DispatchQueue.main.async {
                    cacheImage(image, forURL: url, toDisk: false)
                    self.setImage(image, update: true, animated: animated)
                }
            }.failure { error, isCancelled in
                let task = request(resource)
                objc_setAssociatedObject(self, &imageTaskKey, task, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                task.success {
                    cacheImage($0, forURL: url, toDisk: true)
                    self.setImage($0, update: true, animated: animated)
                }
            }
        }
    }
}

extension UIImageView: ImageDisplaying {
    public func setImage(_ image: UIImage?, update: Bool, animated: Bool) {
        let setter = { self.image = image }
        if animated && self.image == nil {
            UIView.transition(with: self, duration: defaultAnimationDuration, options: [.transitionCrossDissolve, .allowUserInteraction], animations: setter, completion: nil)
        } else {
            setter()
        }
    }
}

private enum Size: String {
    case defaultSize
}
