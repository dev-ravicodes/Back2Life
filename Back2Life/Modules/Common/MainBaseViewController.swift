//
//  MainBaseViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit
import Designable
import SideMenu
import Presentr
import CoreLocation

class MainBaseViewController: BaseViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    var navBar: UINavigationBar = UINavigationBar()
    let presentr = Presentr(presentationType: .fullScreen)
    var locationManager : LocationManager?
    
    
    private lazy var onlineOfflineView: DesignableButton = {
        var button: DesignableButton = DesignableButton()
        button.backgroundColor = AppColor.primaryThemeColor
        button.setTitle("Online".capitalized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.font(style: .bold, size: 12)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 4)
        button.fullyRoundedCorners = true
        return button
    }()
    
    struct LeftNavItem: OptionSet {
        let rawValue: Int
        
        static let profile = LeftNavItem(rawValue: 1 << 0)
        static let notification = LeftNavItem(rawValue: 1 << 1)
        
        static let all: LeftNavItem = [.profile, .notification]
    }
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarToTheView()
    }
    
    // MARK: - Layout
    
    func setNavBarToTheView() {
        self.navBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45)  // Here you can set you Width and Height for your navBar
        self.navBar.backgroundColor = (UIColor.black)
        addImageNav()
        // addViewNav()
        self.view.addSubview(navBar)
    }
    
    func addViewNav() {
        
        let myNewView = UIView(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width, height: 200))
        myNewView.backgroundColor=UIColor.lightGray
        myNewView.layer.cornerRadius=25
        myNewView.layer.borderWidth=2
        myNewView.layer.borderColor = UIColor.red.cgColor
        // Add UIView as a Subview
        addImageNav()
        self.view.addSubview(myNewView)
        
    }
    
    
    func addImageNav() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 253, height: 100))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "back_to_life_logo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func addLeftNavMenuButton() {
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuButtonAction(_ :)))
        navigationItem.leftBarButtonItem = button
    }
    
    
    @objc func profileButtonAction(_ sender: UIBarButtonItem) {
        navigate(.profile(isFromHome: true))
    }
    
    @objc func notificationButtonAction(_ sender: UIBarButtonItem) {
        navigate(.notification)
    }
    
    func addRightNavButtons(navItems: LeftNavItem) {
        var items: [UIBarButtonItem] = []
        
        if navItems.contains(.profile) || navItems.contains(.all) {
            let button = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(profileButtonAction(_ :)))
            items.append(button)
        }
        
        if navItems.contains(.notification) || navItems.contains(.all) {
            let button = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notificationButtonAction(_ :)))
            items.append(button)
        }
        
        navigationItem.rightBarButtonItems = items
    }
    
    func addOnlineOfflineMiddleNavView() {
        navigationItem.titleView = onlineOfflineView
        onlineOfflineView.layoutIfNeeded()
        onlineOfflineView.addSpaceBetweenImageAndTitle(spacing: 8)
    }
    
    func enableSideMenu() {
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    // MARK: - User Interaction
    
    @objc func menuButtonAction(_ sender: UIBarButtonItem) {
        SideMenu.shared.setupSideMneu()
        present((SideMenuManager.default.leftMenuNavigationController ?? SideMenuManager.default.leftMenuNavigationController)!, animated: true, completion: nil)
    }
    
    func getCurrentAddress(with coordinates:CLLocationCoordinate2D, completion : @escaping(_ : String) -> Void){
        let geocoder = CLGeocoder()
        self.showActivity()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { (placemarks, error) in
            self.hideActivity()
            if (error != nil){
                print("error in reverseGeocode")
                completion("error in fetching location")
            }else{
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    print(placemark)
                    print(placemark.administrativeArea!)
                    print(placemark.country!)
                    UserStoreSingleton.shared.PostalCode = placemark.postalCode!
                    UserStoreSingleton.shared.Address = placemark.locality
                    completion("\(placemark.locality ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")")
                }else{
                    completion("error in fetching location")
                }
            }
        }
    }
    
  
    
}
