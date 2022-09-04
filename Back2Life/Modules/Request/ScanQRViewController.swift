//
//  ScanQRViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

class ScanQRViewController: RequestBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var idView: UIView!
    
    // MARK: - Properties
    
    enum ScanType {
        case new
        case confirm(id: Any)
    }
    
    var scanType: ScanType = .new
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch scanType {
        case .new:
            idView.isHidden = true
        case .confirm:
            // Show the id image here before that change the id type to according value
            idView.isHidden = false
        }
        
        let navButton = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(backButtonAction(_ :)))
        navButton.tintColor = .white
        navigationItem.leftBarButtonItem = navButton
        
        addMidleLogoView()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func idViewButtonAction(_ sender: Any) {
        let vc = Storyboard.Test.viewController(for: ViewQRDetailsViewController.self)
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func scanButtonAction(_ sender: Any) {
        switch scanType {
        case .new:
            let vc = Storyboard.Test.viewController(for: CheckTestDetailsViewController.self)
            vc.providesPresentationContextTransitionStyle = true
            vc.definesPresentationContext = true
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false, completion: nil)
        case .confirm:
            let vc = Storyboard.Test.viewController(for: SendTestResultsViewController.self)
            vc.providesPresentationContextTransitionStyle = true
            vc.definesPresentationContext = true
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false, completion: nil)
        }
    }
    
    // MARK: - Additional Helpers
}
