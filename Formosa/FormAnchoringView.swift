//
//  FormView.swift
//  Formosa
//
//  Created by Jordan Kay on 10/23/18.
//  Copyright © 2018 Cultivr. All rights reserved.
//

public final class FormAnchoringView: UIView {
    public var anchoringInset: CGFloat!
    
    @IBOutlet public private(set) var anchoredActionView: FormActionView!
}

extension FormAnchoringView: Anchoring {
    public var anchoredViews: [UIView] {
        return [anchoredActionView]
    }
}
