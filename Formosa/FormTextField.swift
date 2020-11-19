//
//  FormTextField.swift
//  Formosa
//
//  Created by Jordan Kay on 5/24/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Cipher
import Mensa
import Trestle

public class FormTextField: UITextField, TouchTargetModifying {
    @IBInspectable public private(set) var topTouchOutset: CGFloat = 0
    @IBInspectable public private(set) var leftTouchOutset: CGFloat = 0
    @IBInspectable public private(set) var bottomTouchOutset: CGFloat = 0
    @IBInspectable public private(set) var rightTouchOutset: CGFloat = 0
    
    @IBInspectable private(set) var textMargin: CGFloat = 0
    @IBInspectable private(set) var placeholderColor: UIColor?

    public var formField: FormField! {
        didSet {
            text = formField.existingInput
            placeholder = formField.placeholderText
            keyboardType = formField.keyboardType
            isSecureTextEntry = (formField.securityLevel == .secured)
            autocorrectionType = formField.autocorrectsInput ? .yes : .no
            autocapitalizationType = formField.autocapitalizationType
        }
    }
    
    // MARK: UIView
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let touchTarget = bounds.inset(by: touchInsets)
        return touchTarget.contains(point)
    }
    
    // MARK: UITextField
    public override var placeholder: String? {
        didSet {
            if let string = placeholder, let color = placeholderColor {
                attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
            }
        }
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: textMargin, dy: 0)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    // MARK: NSCoding
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        decodeProperties(from: coder) {
            let actions = coder.decodeObject(forKey: "actions") as? [String] ?? []
            for action in actions {
                addTarget(nil, action: Selector(action), for: .editingChanged)
            }
        }
    }
    
    override open func encode(with coder: NSCoder) {
        super.encode(with: coder)
        encodeProperties(with: coder) {
            coder.encode(actions(forTarget: nil, forControlEvent: .editingChanged), forKey: "actions")
        }
    }
}
