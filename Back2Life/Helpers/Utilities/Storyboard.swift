//
//  Storyboard.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import Foundation
import UIKit

struct Storyboard {
    static let Authentication: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
    static let LaunchScreen: UIStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
    static let Splash: UIStoryboard = UIStoryboard(name: "Splash", bundle: nil)
    static let Main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let Location: UIStoryboard = UIStoryboard(name: "Location", bundle: nil)
    static let Service: UIStoryboard = UIStoryboard(name: "Service", bundle: nil)
    static let Profile: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    static let Home: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
    static let Test: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
    static let Booking: UIStoryboard = UIStoryboard(name: "Booking", bundle: nil)
    static let Menu: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
    static let Notification: UIStoryboard = UIStoryboard(name: "Notification", bundle: nil)
    static let Report: UIStoryboard = UIStoryboard(name: "Report", bundle: nil)
}

extension UIStoryboard {

    public func viewController<T: UIViewController>(for type: T.Type, withIdentifier identifier: String? = nil) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: identifier ?? String(describing: T.self)) as? T else { fatalError("Storyboard ID is missing or wrong") }
        return viewController
    }
}
