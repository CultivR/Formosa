//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa
import Province

@UIApplicationMain
final class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        Registration.register(Tweet.self, with: TweetViewController.self)
        Registration.register(LoadingIndicator.self, with: LoadingIndicatorViewController.self)
        return true
    }
}
