//
//  IntroCell.swift
//  House Flipper Estimator
//
//  Created by Sukhpreet Singh on 07/11/20.
//

import UIKit

class IntroCell: UICollectionViewCell {
    static let identifier = "IntroCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var intro: Intro = Intro.objects[0] {
        didSet {
            imageView.image = intro.image
            titleLabel.text = intro.title
        }
    }
}
