//
//  Navigation.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit

enum Navigation: Navigatable {
    case enterDetails
    case mobileDetails
    case enterOTP
    case home
    case chooseTest
    case licensePlateScanning
    case selectCard
    case paymentByCard
    case payment
    case booking(_ testData : [String:Any],_ isFromTestKit : Bool)
    case profile(isFromHome: Bool)
    case notification
    case report
    case customerReport
    case postivereport(orderId: Int,reportId:Int)
    case negativeReport
    case popTime
    case qrbutton
    case schedulebooking(isBooking: Bool)
    case chatsupport
    case ShareKit
    //case uploadKitPhoto
    
}

struct AppNavigation: AppNavigatable {
    
    func viewcontrollerForNavigation(navigation: Navigatable) -> UIViewController {
        if let navigation = navigation as? Navigation {
            switch navigation {
            
            //case .uploadKitPhoto:
                //return Storyboard.Booking.viewController(for: LicensePlatePhotoUploadViewController.self)
            
            case .chatsupport:
                return Storyboard.Notification.viewController(for: ChatSupport_VC.self)
            case .enterDetails:
                return Storyboard.Authentication.viewController(for: SignInViewController.self)
            case .mobileDetails:
                return Storyboard.Authentication.viewController(for: EnterNumberViewController.self)
            case .enterOTP:
                return Storyboard.Authentication.viewController(for: EnterOTPViewController.self)
            case .home:
                return Storyboard.Home.viewController(for: HomeViewController.self)
            case .chooseTest:
                return Storyboard.Home.viewController(for: ChooseAntigenTestViewController.self)
            case .licensePlateScanning:
                return Storyboard.Authentication.viewController(for: LicensePlateScanningViewController.self)
            case .payment:
             return Storyboard.Booking.viewController(for: PayByCardViewController.self)
                //vc.bookingConfirm = .schedule
               // return vc
            case .selectCard:
                return Storyboard.Booking.viewController(for: PaymentMethodViewController.self)
            case .paymentByCard:
                let vc = Storyboard.Home.viewController(for: HomeViewController.self)
               // vc.bookingConfirm = "ComeFrom"
                return vc
            case .booking(let arr,let isFromTestKit):
                let vc = Storyboard.Booking.viewController(for: BookAppointmentViewController.self)
                vc.testData = arr
                vc.isFromTestKit = isFromTestKit
                return vc
            case .profile(let isFromHome):
                let vc = Storyboard.Profile.viewController(for: ProfileViewController.self)
                vc.isFromHome = isFromHome
                return vc
//            case .profile:
//                return Storyboard.Profile.viewController(for: ProfileViewController.self)
            case .qrbutton:
                return Storyboard.Booking.viewController(for: ViewQRViewController.self)
            case .popTime:
                return Storyboard.Booking.viewController(for: PopReceivedBookingViewController.self)
            case .notification:
                return Storyboard.Notification.viewController(for: NotificationViewController.self)
            case .report:
                return Storyboard.Report.viewController(for: ReportViewController.self)
            case .customerReport:
                return Storyboard.Report.viewController(for: reportPostiveViewController.self)
            case .postivereport(let orderId, let reportId ):
                let vc = Storyboard.Report.viewController(for: reportPostiveViewController.self)
                vc.ComeFrom = "TestReport"
              //  vc.orderId = orderId
              //  vc.reportId = reportId
                return vc
            
//            case .postivereport:
//                return Storyboard.Report.viewController(for: reportPostiveViewController.self)
            case .negativeReport:
                return Storyboard.Report.viewController(for: reportNegativeViewController.self)
                
            case .schedulebooking(let isBooking):
                let vc = Storyboard.Booking.viewController(for: ScheduleBookingsViewController.self)
                vc.isBooking = isBooking
                return vc
            case .ShareKit:
                return Storyboard.Notification.viewController(for: ShareKitViewController.self)
            }
        }else {
            // FIXME: Implement other `Navigation`
            fatalError("Implement")
        }
    }
    
    func navigate(_ navigation: Navigatable, from: UIViewController, to: UIViewController) {
        from.navigationController?.pushViewController(to, animated: true)
    }
}

extension UIViewController {
    
    func navigate(_ navigation: Navigation) {
        navigate(navigation as Navigatable)
    }
    func present(_ navigation: Navigation, from: UIViewController, to: UIViewController) {
        from.present(to, animated: true, completion: nil)
    }
    
    class func goToLogin() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            guard let window = appDelegate.window  else {
                return
            }
            guard let rootViewController = window.rootViewController else{return}

            let storyBoard = UIStoryboard.init(name:"Authentication", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController")
            viewController.view.frame = rootViewController.view.frame
            viewController.view.layoutIfNeeded()
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            }, completion: nil)
        }
     }

    class func goToHome() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            guard let window = appDelegate.window  else {
                return
            }
            guard let rootViewController = window.rootViewController else{return}
            let storyBoard = UIStoryboard.init(name:"Home", bundle: nil)

            let viewController = storyBoard.instantiateViewController(withIdentifier: "homeTabC")
            viewController.view.frame = rootViewController.view.frame
            viewController.view.layoutIfNeeded()
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            }, completion: nil)
        }
    }
    
}
