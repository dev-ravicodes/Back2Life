//
//  EnterDetailsViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit
import Designable

class EnterDetailsViewController: AuthenticationBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: AppTextField!
    @IBOutlet weak var phoneNumberTextField: AppTextField!
    @IBOutlet weak var backToLifeTextField: AppTextField!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        backToLifeTextField.delegate = self
        
        addMidleLogoView()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigate(.enterOTP)
    }
    
    // MARK: - Additional Helpers
}

// MARK: - UITextFieldDelegate

extension EnterDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameTextField:
            phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField:
            phoneNumberTextField.becomeFirstResponder()
        case backToLifeTextField:
            // validate, register / navigate
            navigate(.enterOTP)
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}
