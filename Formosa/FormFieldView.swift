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
    
    // MARK: UIView
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: NSCoding
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        decodeProperties(from: coder)
    }
}

public extension FormFieldView {
    // MARK: NSCoding
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        encodeProperties(with: coder)
    }
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
