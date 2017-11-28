//
//  FormTextField.swift
//  Formosa
//
//  Created by Jordan Kay on 5/24/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public protocol CustomPlaceholderLabelProviding {
    var customPlaceholderLabel: UILabel! { get }
}

open class FormTextField: UITextField, TouchTargetModifying {
    @IBInspectable public private(set) var topTouchOutset: CGFloat = 0
    @IBInspectable public private(set) var leftTouchOutset: CGFloat = 0
    @IBInspectable public private(set) var bottomTouchOutset: CGFloat = 0
    @IBInspectable public private(set) var rightTouchOutset: CGFloat = 0
    
    @IBInspectable private(set) var textMargin: CGFloat = 0
    @IBInspectable private(set) var placeholderFont: UIFont?
    @IBInspectable private(set) var placeholderColor: UIColor?
    
    public var formField: FormField! {
        didSet {
            text = formField.existingInput
            keyboardType = formField.keyboardType
            isSecureTextEntry = (formField.securityLevel != .insecure)
            autocorrectionType = formField.autocorrectsInput ? .yes : .no
            autocapitalizationType = formField.autocapitalizationType
            
            if let customPlaceholderLabel = customPlaceholderLabel {
                placeholder = nil
                customPlaceholderLabel.text = formField.placeholderText
                customPlaceholderLabel.sizeToFit()
            } else {
                placeholder = formField.placeholderText
            }
        }
    }
    
    // MARK: UIView
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let touchTarget = UIEdgeInsetsInsetRect(bounds, touchInsets)
        return touchTarget.contains(point)
    }
    
    // MARK: UITextField
    override open var placeholder: String? {
        didSet {
            guard let string = placeholder else { return }
            var attributes: [NSAttributedStringKey: Any] = [:]
            if let font = placeholderFont {
                attributes[.font] = font
            }
            if let color = placeholderColor {
                attributes[.foregroundColor] = color
            }
            attributedPlaceholder = NSAttributedString(string: string, attributes: attributes)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: textMargin, dy: 0)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
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

public extension FormTextField {
    func canChangeCharacters(in range: NSRange, replacementString string: String) -> Bool {
        guard let regex = formField.validPartialInputRegex else { return true }
        guard let text = text, let stringRange = Range(range, in: text) else { return false }
        
        let updatedText = text.replacingCharacters(in: stringRange, with: string)
        return updatedText.range(of: regex, options: .regularExpression) != nil
    }
}


extension FormTextField {
    func toggleSecurity() {
        isSecureTextEntry = !isSecureTextEntry
        resignFirstResponder()
        becomeFirstResponder()
    }
}

private extension FormTextField {
    var customPlaceholderLabel: UILabel? {
        return (self as? CustomPlaceholderLabelProviding)?.customPlaceholderLabel
    }
}
