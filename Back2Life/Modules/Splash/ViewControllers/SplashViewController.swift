//
//  SplashViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit
import Designable

class SplashViewController: MainBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundView: DesignableView!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLeftNavMenuButton()
        
      //  addRightNavButtons(navItems: .all)
        addImageNav()
      //  addOnlineOfflineMiddleNavView()
      //  backgroundView.roundedCorners(corners: [.leftTop, .rightTop], with: 30)
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    // MARK: - Additional Helpers
    
    @IBAction func tapContinueButtonAction(_ sender: Any) {
        navigate(.enterDetails)
    }
}
