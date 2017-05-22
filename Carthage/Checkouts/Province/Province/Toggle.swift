//
//  Toggle.swift
//  Province
//
//  Created by Jordan Kay on 5/15/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

public protocol AsyncToggleable {
    associatedtype Representation
    
    func representation(for state: ToggleAsyncState) -> Representation
}

extension AsyncToggleable where Self: UIButton, Representation: UIImage {
    public func update(with state: ToggleAsyncState, allowsDisable: Bool = false) {
        switch state {
        case .on:
            isEnabled = true
            setImage(representation(for: .on), for: .normal)
            setImage(representation(for: .turningOff), for: .highlighted)
        case .off:
            isEnabled = true
            setImage(representation(for: .off), for: .normal)
            setImage(representation(for: .turningOn), for: .highlighted)
        case .turningOn:
            isEnabled = !allowsDisable
            setImage(representation(for: .turningOn), for: .normal)
        case .turningOff:
            isEnabled = !allowsDisable
            setImage(representation(for: .turningOff), for: .normal)
        }
    }
}
