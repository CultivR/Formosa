//
//  AppDelegate.swift
//  FormosaExample
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Formosa
import Mensa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Registration.register(itemType: FormAction.self, conformingTypes: [AuthenticationFormAction.self], viewType: FormActionView.self, controllerType: FormActionViewController.self)
        Registration.register(itemType: FormField.self, conformingTypes: [AuthenticationFormField.self], viewType: FormFieldView.self, controllerType: FormFieldViewController.self)
        Registration.register(itemType: String.self, viewType: StringView.self, controllerType: StringViewController.self)
        return true
    }
}

extension UIViewController {
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
