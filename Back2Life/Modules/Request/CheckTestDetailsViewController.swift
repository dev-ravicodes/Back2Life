//
//  CheckTestDetailsViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

class CheckTestDetailsViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: AppTextField!
    @IBOutlet weak var addressTextField: AppTextField!
    @IBOutlet weak var postalcodeTextField: AppTextField!
    @IBOutlet weak var cityTextField: AppTextField!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        postalcodeTextField.delegate = self
        cityTextField.delegate = self
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let vc = Storyboard.Test.viewController(for: ScanQRViewController.self)
        let navVc = BaseNavigationViewController(rootViewController: vc)
        vc.scanType = .confirm(id: "Check")
        navVc.providesPresentationContextTransitionStyle = true
        navVc.definesPresentationContext = true
        navVc.modalPresentationStyle = .overFullScreen
        navVc.modalTransitionStyle = .crossDissolve
        present(navVc, animated: false, completion: nil)
    }
    
    // MARK: - Additional Helpers
}

// MARK: - UITextFieldDelegate

extension CheckTestDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameTextField:
            addressTextField.becomeFirstResponder()
        case addressTextField:
            postalcodeTextField.becomeFirstResponder()
        case postalcodeTextField:
            cityTextField.becomeFirstResponder()
        case cityTextField:
            // validate, register / navigate
            break
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

