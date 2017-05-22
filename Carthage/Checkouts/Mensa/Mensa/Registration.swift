//
//  Registration.swift
//  Mensa
//
//  Created by Jordan Kay on 5/5/17.
//  Copyright © 2017 Jordan Kay. All rights reserved.
//

public enum Registration {
    private(set) static var viewTypes: [String: UIView.Type] = [:]
    private(set) static var viewControllerTypes: [String: () -> ItemDisplayingViewController] = [:]
    
    // Globally register a view controller type to use to display an item type.
    public static func register<T, ViewController: UIViewController>(_ itemType: T.Type, conformingTypes: [Any.Type] = [], with viewControllerType: ViewController.Type) where ViewController: ItemDisplaying, T == ViewController.Item {
        let types = [itemType] + conformingTypes
        for type in types {
            let key = String(describing: type)
            viewTypes[key] = viewControllerType.viewType
            viewControllerTypes[key] = {
                let viewController = viewControllerType.init()
                return ItemDisplayingViewController(viewController)
            }
        }
    }
}

extension UIViewController {
    static var viewType: UIView.Type {
        let name = String(describing: self).replacingOccurrences(of: "ViewController", with: "View")
        let namespace = Bundle(for: self).object(forInfoDictionaryKey: "CFBundleName") as! String
        let className = "\(namespace).\(name)"
        return NSClassFromString(className) as! UIView.Type
    }
}
