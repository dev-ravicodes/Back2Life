//
//  AuthenticationBaseViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 14/05/21.
//

import UIKit
import Designable

class AuthenticationBaseViewController: BaseViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    private lazy var middleLogoView: DesignableImageView = {
        var view: DesignableImageView = DesignableImageView()
        view.image = UIImage(named: "logo.small")
        view.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.height).multipliedBy(1 / 0.39)
        }
        return view
    }()
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Layout
    
    func addMidleLogoView() {
        navigationItem.titleView = middleLogoView
    }
    
    // MARK: - User Interaction
    
    // MARK: - Additional Helpers
}
