//
//  FormFieldView.swift
//  Formosa
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Mensa

public final class FormFieldView: UIView {
    @IBOutlet public private(set) var label: UILabel?
    @IBOutlet public private(set) var textField: FormTextField!
}

extension FormFieldView: Displayed {
    public func update(with formField: FormField, variant: DisplayInvariant) {
        label?.text = formField.name
        textField.formField = formField
    }
}
