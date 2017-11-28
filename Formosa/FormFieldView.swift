//
//  FormFieldView.swift
//  Formosa
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public final class FormFieldView: UIView {
    @IBOutlet public private(set) var label: UILabel?
    @IBOutlet public private(set) var textField: FormTextField!
    @IBOutlet public private(set) var securityToggleButton: Button?
}

extension FormFieldView: Displayed {
    public func update(with formField: FormField, variant: DisplayInvariant) {
        label?.text = formField.name
        securityToggleButton?.isHidden = (formField.securityLevel != .securable)
        textField.formField = formField
    }
}

private extension FormFieldView {
    @IBAction func toggleSecurity() {
        securityToggleButton!.toggle()
        textField.toggleSecurity()
    }
}
