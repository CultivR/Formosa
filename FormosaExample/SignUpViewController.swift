//
//  SignUpViewController.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: NSObject
    override func awakeAfter(using coder: NSCoder) -> Any? {
        let form = SignUpForm()
        return AuthenticationViewController(form: form, coder: coder)
    }
}
