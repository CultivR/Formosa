//
//  DisplayStyle.swift
//  Province
//
//  Created by Jordan Kay on 5/14/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Province
import SwiftTask

enum DisplayStyle {
    case light
    case dark
    
    var color: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .darkGray
        }
    }
    
    var string: String {
        switch self {
        case .light:
            return "⚪️"
        case .dark:
            return "⚫️"
        }
    }
}

extension DisplayStyle: State {
    func transition<P, V, E: Error>(with transition: ToggleTransition, task: Task<P, V, E>, update: @escaping (DisplayStyle) -> Void) throws {}
    
    func transition(with transition: ToggleTransition, update: @escaping (DisplayStyle) -> Void) throws {
        switch self {
        case .light:
            update(.dark)
        case .dark:
            update(.light)
        }
    }
}
