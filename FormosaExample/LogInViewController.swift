//
//  LogInViewController.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    // MARK: NSObject
    override func awakeAfter(using coder: NSCoder) -> Any? {
        let form = LogInForm()
        return AuthenticationViewController(form: form, coder: coder)
    }
}
