//
//  SendTestResultsViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

class SendTestResultsViewController: BaseViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties

    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func possitiveButtonAction(_ sender: Any) {
        let vc = Storyboard.Test.viewController(for: TestSubmitedViewController.self)
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func negativeButtonAction(_ sender: Any) {
        let vc = Storyboard.Test.viewController(for: TestSubmitedViewController.self)
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    // MARK: - Additional Helpers
}
