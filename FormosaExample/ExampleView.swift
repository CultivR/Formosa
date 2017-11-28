//
//  ExampleView.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Mensa
import Province

final class ExampleView: UIView {
    @IBOutlet private var label: UILabel!
}

extension ExampleView: Displayed {
    func update(with state: ExampleAuthenticationState, variant: DisplayVariant) {
        var text: String? = nil
        switch state {
        case .loggedIn(let api):
            guard let username = api.account?.username else { return }
            text = Strings.loggedInLabel.localized(username)
        case .loggedOut:
            text = Strings.loggedOutLabel.localized
        case .failedToLogIn:
            text = Strings.failedToLogInTitle.localized
        default:
            break
        }
        if let text = text {
            let symbol = state.isLoggedIn ? "🔵" : "🔴"
            label.text = "\(symbol) \(text)"
        }
    }
}
