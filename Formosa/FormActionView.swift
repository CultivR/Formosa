//
//  FormActionView.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Mensa
import Trestle

public final class FormActionView: UIView {
    @IBOutlet public private(set) var button: Button!
}

extension FormActionView: Displayed {
    public func update(with action: FormAction, variant: DisplayInvariant) {
        button.text = action.name
        button.setTitle(action.name, for: .normal)
    }
}
