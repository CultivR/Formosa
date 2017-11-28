//
//  FormActionView.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public final class FormActionView: Block {
    var isEnabled: Bool = true {
        didSet {
            button.isEnabled = isEnabled
        }
    }
    
    @IBOutlet public private(set) var button: Button!
    
    @IBInspectable private(set) var buttonText: String?
    
    // MARK: Block
    override open func finishSetup() {
        guard let text = buttonText else { return }
        button.text = text
    }
}
extension FormActionView: Displayed {
    public func update(with action: FormAction, variant: DisplayInvariant) {
        button.text = action.name
    }
}
