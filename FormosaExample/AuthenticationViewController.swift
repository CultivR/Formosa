//
//  AuthenticationViewController.swift
//  Formosa
//
//  Created by Jordan Kay on 5/25/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Klaxon
import UIKit

class AuthenticationViewController<FormType: AuthenticationForm>: FormViewController<FormType> where FormType.SubmissionError: KlaxonError {
    // MARK: FormViewController
    override init?(form: FormType, coder: NSCoder) {
        super.init(form: form, coder: coder)
        title = FormType.name
    }
    
    // MARK: NSCoding
    required init?(coder: NSCoder) {
        fatalError()
    }
}
