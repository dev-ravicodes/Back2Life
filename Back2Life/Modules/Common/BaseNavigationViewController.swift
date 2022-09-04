//
//  BaseNavigationViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        darkNavigationBar()
    }
    
    func darkNavigationBar() {
        if #available(iOS 13.0, *) {
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: AppFont.font(style: .bold, size: 25)]
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: AppFont.font(style: .bold, size: 21)]
            navBarAppearance.backgroundColor = .black
            
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
            
        } else {
            
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: AppFont.font(style: .bold, size: 25)]
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: AppFont.font(style: .bold, size: 21)]
            navigationBar.backgroundColor = .black
        }
    
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.setBackgroundImage(UIImage(named: "back_to_life_logo"), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .black
        
    }
    func addImageNav() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: -30, width: 253, height: 100))
        imageView.backgroundColor = UIColor.blue
        imageView.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFit
           let image = UIImage(named: "back_to_life_logo")
           imageView.image = image
           navigationItem.titleView = imageView
    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

