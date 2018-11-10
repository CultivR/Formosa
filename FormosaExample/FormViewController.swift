//
//  FormViewController.swift
//  FormosaExample
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Formosa
import Klaxon
import Mensa
import Province

class FormViewController<FormType: Form>: UIViewController, StatefulTODO where FormType.SubmissionError: KlaxonError {
    private(set) lazy var state  = FormViewControllerState<FormViewController<FormType>>(delegate: self)
    
    private var form: FormType
    private var submitActionView: FormActionView!
    
    @IBAction func updateInput(from textField: FormTextField) {
        let formField = textField.formField as! FormType.FormFieldType
        form[formField] = textField.text!
    }
    
    @IBAction func attemptFormSubmission() {
        state.attemptSubmission(of: form)
    }
    
    init?(form: FormType, coder: NSCoder) {
        self.form = form
        super.init(coder: coder)
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplayContext()
    }
    
    // MARK: NSCoding
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension FormViewController: DataDisplaying {
    typealias Item = FormType.Item
    typealias View = UIView
    typealias TableViewType = FormDataView
    
    var dataSource: FormType {
        return form
    }
    
    var displayContext: DataDisplayContext {
        return .tableView(separatorInset: 0, separatorPlacement: .allCellsButLast)
    }
    
    func use(_ view: UIView, with item: FormType.Item, variant: DisplayVariant, displayed: Bool) {
        if displayed {
            submitActionView = view as? FormActionView
        }
    }
    
    func setupDataView() {
        dataView.isScrollEnabled = false
    }
}

extension FormViewController: FormViewControllerStateDelegate {
    func state<T>(_ state: FormViewControllerState<T>, didUpdate formSubmissionState: SubmissionState<FormValidityError<FormType>, FormType.SubmissionError>) {
        switch formSubmissionState {
        case .submitted:
            dismiss()
        case .submitting:
            disableSubmission()
        case let .failedToSubmit(error):
            UIAlertController.showError(error)
            enableSubmission()
        default:
            break
        }
    }
}

private extension FormViewController {
    func enableSubmission() {
        submitActionView.button.isEnabled = true
    }
    
    func disableSubmission() {
        submitActionView.button.isEnabled = false
    }
}
