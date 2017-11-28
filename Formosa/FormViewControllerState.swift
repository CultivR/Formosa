//
//  FormViewControllerState.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Province
import SwiftTask

public class FormViewControllerState<Delegate: FormViewControllerStateDelegate>: StateHolder {
    public typealias FormType = Delegate.FormType
    
    public private(set) weak var delegate: Delegate!
    
    private var formSubmissionState: SubmissionState<FormType.Resource, FormValidityError<FormType>, FormType.SubmissionError> = .ableToSubmit {
        didSet {
            delegate.state(self, didUpdate: formSubmissionState)
        }
    }
    
    public required init(delegate: Delegate) {
        self.delegate = delegate
    }
    
    public func checkValidity(of form: FormType) {
        checkValidity(of: form, submit: false)
    }
    
    public func attemptSubmission(of form: FormType) {
        checkValidity(of: form, submit: true)
    }
    
    public func submit(_ form: FormType) {
        let task = form.submit()
        try! formSubmissionState.transition(with: .submit, task: task) { [weak self] in
            self?.formSubmissionState = $0
        }
    }
}

private extension FormViewControllerState {
    func checkValidity(of form: FormType, submit: Bool) {
        let task = form.checkValidity()
        try! formSubmissionState.transition(with: .checkValidity, task: task) { [weak self] in
            guard let `self` = self else { return }
            self.formSubmissionState = $0
            if case .ableToSubmit = $0, submit {
                self.submit(form)
            }
        }
    }
}

public protocol FormViewControllerStateDelegate: class {
    associatedtype FormType: Form
    
    func state<T>(_ state: FormViewControllerState<T>, didUpdate formSubmissionState: SubmissionState<FormType.Resource, FormValidityError<FormType>, FormType.SubmissionError>)
}
