//
//  FormFieldSecurityLevel.swift
//  Formosa
//
//  Created by Jordan Kay on 5/25/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Province
import SwiftTask

public enum FormFieldSecurityLevel {
    public enum Transition {
        case toggleSecurity
    }

    case insecure
    case securable
    case secured
}

extension FormFieldSecurityLevel: State {
    public func transition(with transition: Transition, update: (FormFieldSecurityLevel) -> Swift.Void) throws {
        switch self {
        case .securable:
            update(.secured)
        case .secured:
            update(.securable)
        default:
            throw error(using: transition)
        }
    }
    
    public func transition<P, V, E: Error>(with transition: Transition, task: Task<P, V, E>, update: @escaping (FormFieldSecurityLevel) -> Void) throws {
        throw error(using: transition)
    }
}
