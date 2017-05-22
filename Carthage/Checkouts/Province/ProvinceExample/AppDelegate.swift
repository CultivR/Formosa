//
//  AppDelegate.swift
//  ProvinceExample
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa

@UIApplicationMain
final class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        Registration.register(Quote.self, with: QuoteViewController.self)
        return true
    }
}
