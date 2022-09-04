//
//  IntroRootVC.swift
//  House Flipper Estimator
//
//  Created by Sukhpreet Singh on 05/11/20.
//

import UIKit

class IntroRootVC: UIViewController {
    
    @IBOutlet weak var pageControl: HFPagerView! {
        didSet {
            pageControl.numberOfPages = Intro.objects.count
            pageControl.currentPage = 0
            pageControl.tint = UIColor.red
            pageControl.currentTint = UIColor.blue
        }
    }
    
    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.color(.white)
        IntroCVC.indexPathChanged = updateIndex(_:)
    }
    
    func updateIndex(_ value: Int) {
        pageControl.currentPage = value
    }
}

