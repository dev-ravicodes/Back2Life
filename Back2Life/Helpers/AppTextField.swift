//
//  AppTextField.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import Foundation
import SkyFloatingLabelTextField

class AppTextField: SkyFloatingLabelTextFieldWithIcon {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        selectedTitleColor = AppColor.primaryColor
        titleColor = AppColor.secondaryLabelColor
        selectedTitleColor = AppColor.secondaryLabelColor
        textColor = AppColor.primaryLabelColor
        lineColor = AppColor.primaryThemeColor
        selectedLineColor = AppColor.primaryThemeColor
        iconType = .image
        iconImage = UIImage(named: "red.heart")
        titleFont = AppFont.font(style: .regular, size: 12)
        placeholderFont = AppFont.font(style: .regular, size: 12)
        font = AppFont.font(style: .bold, size: 15)
    }
}
