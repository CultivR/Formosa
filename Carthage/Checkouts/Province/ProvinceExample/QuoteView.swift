//
//  QuoteView.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa
import Province

final class QuoteView: UIView {
    enum Style: Int, DisplayVariant {
        case light
        case dark
    }
    
    @IBOutlet fileprivate var label: UILabel!
    
    // MARK: NSObject
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
    }    
}

extension QuoteView: Displayed {
    func update(with quote: Quote, variant: DisplayVariant) {
        let text = "\(quote.character): \(quote.line)" as NSString
        let string = NSMutableAttributedString(string: text as String, attributes: [NSFontAttributeName: regularFont])
        string.addAttribute(NSFontAttributeName, value: boldFont, range: text.range(of: "\(quote.character):"))
        label.attributedText = string
    }
}

extension QuoteView.Style {
    init(displayStyle: DisplayStyle) {
        switch displayStyle {
        case .light:
            self = .light
        case .dark:
            self = .dark
        }
    }
}

private extension QuoteView {
    func setupFonts() {
        guard let text = label.attributedText else { return }
        boldFont = text.attributes(at: 0, effectiveRange: nil)[NSFontAttributeName] as! UIFont
        regularFont = text.attributes(at: text.length - 1, effectiveRange: nil)[NSFontAttributeName] as! UIFont
    }
}

private var boldFont: UIFont!
private var regularFont: UIFont!
