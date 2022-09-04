//
//  RootRouter.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit

final class RootRouter {
    
    /** Replaces root view controller. You can specify the replacment animation type.
     If no animation type is specified, there is no animation */
    func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { assertionFailure("Need to update"); return }
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.33, options: animationOptions, animations: {
            }, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }
    
    func loadMainAppStructure() {
        // Customize your app structure here
        let controller = BaseNavigationViewController(rootViewController: Storyboard.Splash.viewController(for: TutorialViewController.self))
        SideMenu.shared.setupSideMneu()
        setRootViewController(controller: controller, animatedWithOptions: nil)
    }
    
    func loadHomeModuleStructure() {
        // Customize your app structure here
        let controller = BaseNavigationViewController(rootViewController: Storyboard.Home.viewController(for: HomeViewController.self))
        SideMenu.shared.setupSideMneu()
        setRootViewController(controller: controller, animatedWithOptions: nil)
    }
}
