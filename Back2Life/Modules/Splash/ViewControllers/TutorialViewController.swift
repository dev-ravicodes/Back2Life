//
//  TutorialViewController.swift
//  UIPageViewController Post
//
//  Created by Jeffrey Burt on 2/3/16.
//  Copyright © 2016 Seven Even. All rights reserved.
//

import UIKit
import Designable
import CoreLocation

class TutorialViewController: MainBaseViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var arrowButton: UIButton!
    //@IBOutlet weak var topView: DesignableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var tutorialMoveDelegate: TutorialViewController?
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  addLeftNavMenuButton()
        addImageNav()
        //addViewNav()
      //  addRightNavButtons(navItems: .all)
        //arrowButton.isHidden = true
        pageControl.addTarget(self, action: Selector("didChangePageControlValue"), for: .valueChanged)
        //topView.roundedCorners(corners: [.leftTop, .rightTop], with: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager = LocationManager(controller: self, locationDelegate: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        navigate(.enterDetails)
    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        if count == 3 {
            // print(count)
            //arrowButton.isHidden = false
        }else{
            //arrowButton.isHidden = false
        }
        print(pageControl.numberOfPages)
    }
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        // print(index)
        if pageControl.currentPage == 3 {
            //arrowButton.isHidden = false
            view.backgroundColor = .blue
        }else{
            //arrowButton.isHidden = true
        }
    }
    
}

extension TutorialViewController : LocationManagerDelegate{
    func currentLocation(coordinates: CLLocationCoordinate2D) {
        UserStoreSingleton.shared.currentLat = coordinates.latitude
        UserStoreSingleton.shared.currentLong = coordinates.longitude
        self.getCurrentAddress(with: coordinates) { (address) in
            //self.locationLabel.text = address
        }
    }
}
