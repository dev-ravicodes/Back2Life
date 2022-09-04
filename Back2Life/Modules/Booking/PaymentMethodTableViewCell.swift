//
//  PaymentMethodTableViewCell.swift
//  Back2Life
//
//  Created by Sachin Kumar on 20/05/21.
//  Copyright © 2021 Sachin Kumar. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var cardImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var selectedImageView: UIImageView!
    
    
    //MARK: -  Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        let rendring = selectedImageView.image?.withRenderingMode(.alwaysTemplate)
        selectedImageView.image = rendring
        selectedImageView.backgroundColor = .white
        selectedImageView.tintColor = .white
        selectedImageView.layer.masksToBounds = true
        selectedImageView.layer.borderWidth = 2.0
        selectedImageView.layer.borderColor = UIColor.red.cgColor
        selectedImageView.layer.cornerRadius = selectedImageView.bounds.width/2
        
    }
    
    
    //MARK: - Helpers
    func populateUI(property: Property) {
        cardImage.image = UIImage(named: property.image)
        nameLabel.text = property.name
        selectedImageView.image = property.isSelected ? UIImage(named: "selectedButton") : UIImage(named: "deselectedButton")
    }
    
}
