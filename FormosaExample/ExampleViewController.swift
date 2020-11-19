//
//  ExampleViewController.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Perform
import Province

final class ExampleViewController: UIViewController {
    @IBOutlet private var signUpItem: UIBarButtonItem!
    @IBOutlet private var logInOrOutItem: UIBarButtonItem!
    
    @IBAction func signUp() {
        perform(.signUp)
    }

    @IBAction func logInOrOut() {
        let session = ExampleSession.current
        switch authenticationState {
        case .loggedIn:
            session.logOut()
        default:
            perform(.logIn)
        }
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        setupSignUpItem()
        updateLogInOrOutItem()
        updateExampleView()

        AuthenticationNotification.addObserver(self, selector: #selector(authenticationStateDidUpdate), name: .didUpdate, object: nil)
    }
}

private extension ExampleViewController {
    var exampleView: ExampleView {
        return view as! ExampleView
    }
    
    var authenticationState: ExampleAuthenticationState {
        return ExampleSession.current.authenticationState
    }
    
    func setupSignUpItem() {
        signUpItem.title = Strings.signUpLabel.localized
    }
    
    func updateLogInOrOutItem() {
        switch authenticationState {
        case .loggingIn:
            logInOrOutItem.isEnabled = false
        case .loggedIn:
            logInOrOutItem.isEnabled = true
            logInOrOutItem.title = Strings.logOutLabel.localized
        case .loggedOut, .failedToLogIn:
            logInOrOutItem.isEnabled = true
            logInOrOutItem.title = Strings.logInLabel.localized
        }
    }
    
    func updateExampleView() {
        exampleView.update(with: authenticationState)
    }
    
    @objc func authenticationStateDidUpdate() {
        updateLogInOrOutItem()
        updateExampleView()
    }
}
