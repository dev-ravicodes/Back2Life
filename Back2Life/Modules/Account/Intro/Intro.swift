//
//  Intro.swift
//  House Flipper Estimator
//
//  Created by Sukhpreet Singh on 06/11/20.
//

import UIKit

struct Intro {
    let image: UIImage
    let title: String
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    static var objects: [Intro] {
        return [Intro(image: #imageLiteral(resourceName: "splash_1"), title: "Estimate your potential house flip profit the easy way"),
                Intro(image: #imageLiteral(resourceName: "splash_2"), title: "Calculate potential profit over customizable timelines"),
                Intro(image: #imageLiteral(resourceName: "splash_3"), title: "Include all the costs to determine the true value")]
    }
}
