//
//  FormViewController.swift
//  Formosa
//
//  Created by Jordan Kay on 10/23/18.
//  Copyright © 2018 Cultivr. All rights reserved.
//

open class FormViewController<FormType: Form & Initializable>: UIViewController, Stateful, KeyboardObserving {
    public private(set) var dataSource: FormType!
    
    public private(set) lazy var state = FormViewControllerState<FormViewController>(delegate: self)
    
    open var formDisplayContext: DataDisplayContext {
        return .tableView(separatorInset: nil, separatorPlacement: .allCells)
    }
    
    open var formFieldViewLayout: DisplayVariant {
        return DisplayInvariant()
    }
    
    open func formActionViewStyle(for action: FormAction) -> DisplayVariant {
        return DisplayInvariant()
    }
    
    open func canSubmitForm(with action: FormAction) -> Bool {
        return false
    }
    
    open func setup(_ actionView: FormActionView) {
        return
    }
    
    open func updateInput(from textField: FormTextField) {
        let formField = textField.formField as! FormType.FormFieldType
        form[formField] = textField.text
        state.checkValidity(of: form)
    }
    
    open func cancelFormSubmissionAndDismiss() {
        state.cancelFormSubmission()
        dismiss(animated: true)
    }
    
    open func receive(_ resource: FormType.Resource) {
        return
    }
    
    open func handle(_ error: FormType.SubmissionError) {
        return
    }
    
    @objc open func attemptFormSubmission() {
        state.attemptSubmission(of: form)
    }
    
    // MARK: UIViewController
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = FormType()
        setDisplayContext()
        addKeyboardObservers()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let actionView = anchoredActionView {
            dataView.frame.size.height = actionView.frame.minY
        }
    }
    
    // MARK: KeyboardObserving
    public func keyboardWillAnimate(notification: Notification) {
        let info = KeyboardInfo(userInfo: notification.userInfo!)
        var formAnchoringView = self.formAnchoringView
        formAnchoringView?.animateAnchoredViews(using: info, adjusting: [dataView])
    }
    
    public func keyboardDidAnimate(notification: Notification) {
        return
    }
}

extension FormViewController: DataDisplaying {
    public typealias Item = FormType.Item
    public typealias DataViewType = UICollectionView
    
    public func setupDataView() {
        view.bringSubview(toFront: dataView)
    }
    
    public var displayContext: DataDisplayContext {
        return formDisplayContext
    }
    
    public func use(_ viewController: UIViewController, with view: UIView, for item: Item, at indexPath: IndexPath, variant: DisplayVariant, displayed: Bool) {
        guard displayed else { return }
        if let formFieldView = view as? FormFieldView {
            let formField = item as! FormType.FormFieldType
            state.update(with: formField, in: form, displayedBy: formFieldView)
        } else if let action = item as? FormAction, let formActionView = view as? FormActionView, canSubmitForm(with: action) {
            state.updateWith(submitActionView: formActionView, form: form)
        }
        if let actionView = anchoredActionView {
            state.updateWith(submitActionView: actionView, form: form)
        }
    }
    
    public func variant(for item: Item, at indexPath: IndexPath) -> DisplayVariant {
        if item is FormType.FormFieldType {
            return formFieldViewLayout
        } else if let action = item as? FormAction {
            return formActionViewStyle(for: action)
        }
        return DisplayInvariant()
    }
}

extension FormViewController: FormViewControllerStateDelegate {
    public func state<T>(_ state: FormViewControllerState<T>, didSetupWith actionView: FormActionView) {
        setup(actionView)
        actionView.button.addTarget(self, action: #selector(attemptFormSubmission), for: .touchUpInside)
    }
    
    public func state<T>(_ state: FormViewControllerState<T>, shouldFocus formFieldView: FormFieldView) {
        formFieldView.textField.becomeFirstResponder()
    }
    
    public func state<T>(_ state: FormViewControllerState<T>, didUpdate formSubmissionState: SubmissionState<FormType.Resource, FormValidityError<FormType>, FormType.SubmissionError>) {
        if case let .submitted(resource) = formSubmissionState {
            receive(resource)
        } else if case let .failedToSubmit(error) = formSubmissionState, FormType.isErrorReported {
            handle(error)
        }
    }
}

private extension FormViewController {
    var form: FormType {
        get {
            return dataSource
        }
        set {
            dataSource = newValue
        }
    }
    
    var formAnchoringView: FormAnchoringView? {
        return view as? FormAnchoringView
    }
    
    var anchoredActionView: FormActionView? {
        return formAnchoringView?.anchoredActionView
    }
}
