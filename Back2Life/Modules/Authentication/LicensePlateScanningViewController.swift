//
//  LicensePlateScanningViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit

class LicensePlateScanningViewController: AuthenticationBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var licenseNumberTextField: AppTextField!
    @IBOutlet weak var landTextField: AppTextField!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        licenseNumberTextField.delegate = self
        landTextField.delegate = self
        addMidleLogoView()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        let router = RootRouter()
        router.loadHomeModuleStructure()
    }
    
    // MARK: - Additional Helpers
}

// MARK: - UITextFieldDelegate

extension LicensePlateScanningViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case licenseNumberTextField:
            licenseNumberTextField.becomeFirstResponder()
        case landTextField:
            // validate, register / navigate
            navigate(.enterOTP)
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}
