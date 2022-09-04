//
//  AppColor.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import Foundation
import Designable

struct AppColor {
    
    // TODO: - Change me
    public static let primaryColor: Color = {
        if #available(iOS 13.0, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return Color.black
                } else {
                    return Color.white
                }
            }
        } else {
            return Color.white
        }
    }()
    
    public static let primaryThemeColor: Color = Color(named: "AppPrimaryThemeColor")!
    public static let primaryLabelColor: Color = Color(named: "AppPrimaryLabelColor")!
    public static let primaryBackgroundColor: Color = Color(named: "AppPrimaryBackgroundColor")!
    public static let secondaryBackgroundColor: Color = Color(named: "AppSecondaryBackgroundColor")!
    public static let secondaryLabelColor: Color = Color(named: "AppSecondaryLabelColor")!
}
