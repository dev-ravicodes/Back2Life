//
//  MenuViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 14/05/21.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    //GreenViewController
    // MARK: - Properties
    
    private var options: [String] = [
        "MEINE BESTELLUNG",
        
        "Terminübersicht",
        //"TESTER KONTAKTIEREN",
        "Testergebnisse",
        "APP TEILEN",
        //"ZAHLUNG VERWALTEN",
        "Chat Support",
        "Test Kit teilen",
        
        "Logout"
    ]
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        navigationController?.navigationBar.isHidden = true
        tableView.layoutIfNeeded()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func cancellButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func shareApp() {
        
    // image to share
            let image = UIImage(named: "Image")
            
            // set up activity view controller
            let imageToShare = [ image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    
    // MARK: - Additional Helpers
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            dismiss(animated: true, completion: nil)
            backScreen = "MEINE BESTELLUNG"
            navigate(.schedulebooking(isBooking: false))
        case 1:
            dismiss(animated: true, completion: nil)
            backScreen = "Terminübersicht"
            navigate(.schedulebooking(isBooking: true))
        case 2:
                dismiss(animated: true, completion: nil)
         //   dismiss(animated: true, completion: nil)
          //  navigate(.notification)
        case 3:
                shareApp()

           
        case 4:
                dismiss(animated: true, completion: nil)
                navigate(.chatsupport)
                
            
        case 5:
                dismiss(animated: true, completion: nil)
                navigate(.ShareKit)
          //  dismiss(animated: true, completion: nil)

            case 6:
                self.showCustomAlert("Möchten Sie sich wirklich abmelden?", "Ausloggen", .destructive) {
                    UserStoreSingleton.shared.isLoggedIn = nil
                    UserStoreSingleton.shared.userToken = nil
                    UserStoreSingleton.shared.fcmToken = nil
                    if let delegate = UIApplication.shared.delegate as? AppDelegate{
                        self.dismiss(animated: true, completion: nil)
                        delegate.setRootController()
                    }
                }
            break
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row].uppercased()
        return cell
    }
}

class SideMenu: NSObject {
    
    public static let shared: SideMenu = SideMenu()
    
    private override init() {
        super.init()
        
    }
    
    public func setupSideMneu() {
        setupSideMenu()
        updateMenus()
    }
    
    private func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = SideMenuNavigationController(rootViewController: Storyboard.Menu.viewController(for: MenuViewController.self))
    }
    
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return modes[0]
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = UIColor.black
        presentationStyle.menuStartAlpha = 0.8
        presentationStyle.menuScaleFactor = 1
        presentationStyle.onTopShadowOpacity = 0.8
        presentationStyle.presentingEndAlpha = 0.8
        presentationStyle.presentingScaleFactor = 1
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = UIScreen.main.bounds.width * CGFloat(0.8)
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 1
        
        return settings
    }
}

extension SideMenu: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}
