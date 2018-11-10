//
//  FormViewControllerState.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public class FormViewControllerState<Delegate: FormViewControllerStateDelegate>: StateHolderTODO {
    public typealias FormType = Delegate.FormType
    private typealias FormSubmissionState = SubmissionState<FormType.Resource, FormValidityError<FormType>, FormType.SubmissionError>
    
    public private(set) weak var delegate: Delegate!
    
    private var focusedFormField: FormType.FormFieldType?
    private var submitActionView: FormActionView?
    private var runningSubmitTask: FormType.SubmitTask?
    private var runningCheckValidityTask: FormType.CheckValidityTask?
    
    private var formSubmissionState: FormSubmissionState = .ableToSubmit {
        didSet {
            submitActionView?.button.updateSubmission(with: formSubmissionState)
            delegate.state(self, didUpdate: formSubmissionState)
        }
    }
    
    public required init(delegate: Delegate) {
        self.delegate = delegate
    }
}

public extension FormViewControllerState {
    func update(with formField: FormType.FormFieldType, in form: FormType, displayedBy formFieldView: FormFieldView) {
        if formField == FormType.initiallyFocusedFormField {
            try? focusedFormField.transition(with: .value(with: formField)) {
                focusedFormField = $0
                delegate.state(self, shouldFocus: formFieldView)
            }
        }
    }
    
    func updateWith(submitActionView: FormActionView, form: FormType) {
        try? self.submitActionView.transition(with: .value(with: submitActionView)) {
            self.submitActionView = $0
            checkValidity(of: form)
            delegate.state(self, didSetupWith: $0!)
        }
    }
    
    func checkValidity(of form: FormType) {
        checkValidity(of: form, submit: false)
    }
    
    func attemptSubmission(of form: FormType) {
        checkValidity(of: form, submit: true)
    }
    
    func submit(_ form: FormType) {
        runningSubmitTask?.cancel()
        runningSubmitTask = form.submit()
        try! formSubmissionState.transition(with: .submit, task: runningSubmitTask!) { [weak self] in
            self?.formSubmissionState = $0
        }
    }
    
    func cancelFormSubmission() {
        runningCheckValidityTask?.cancel()
        runningSubmitTask?.cancel()
    }
}

private extension FormViewControllerState {
    func checkValidity(of form: FormType, submit: Bool) {
        if !submit {
            submitActionView?.isEnabled = false
        }

        runningCheckValidityTask?.cancel()
        runningCheckValidityTask = form.checkValidity()
        try! formSubmissionState.transition(with: .checkValidity, task: runningCheckValidityTask!) { [weak self] in
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
    
    func state<T>(_ state: FormViewControllerState<T>, didSetupWith actionView: FormActionView)
    func state<T>(_ state: FormViewControllerState<T>, shouldFocus formFieldView: FormFieldView)
    func state<T>(_ state: FormViewControllerState<T>, didUpdate formSubmissionState: SubmissionState<FormType.Resource, FormValidityError<FormType>, FormType.SubmissionError>)
}
