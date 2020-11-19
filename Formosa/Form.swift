//
//  Form.swift
//  Formosa
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Mensa
import SwiftTask

public protocol Form: DataSource {
    associatedtype Resource
    associatedtype SubmitProgress
    associatedtype CheckValidityProgress
    associatedtype FormFieldType: FormField, Hashable
    associatedtype SubmissionError: Error

    typealias SubmitTask = Task<SubmitProgress, Resource, SubmissionError>
    typealias CheckValidityTask = Task<CheckValidityProgress, Void, FormValidityError<Self>>
    
    var input: [FormFieldType: String] { get set }
    var representedResource: Resource? { get }
    
    func submit() -> SubmitTask
    func checkValidity() -> CheckValidityTask
    func cancelSubmission()
}

public extension Form {
    mutating func update(_ formField: FormFieldType, withText text: String?) {
        if let text = text, text.count > 0 {
            input[formField] = text
        } else {
            input[formField] = nil
        }
    }
    
    func cancelSubmission() {}
}
