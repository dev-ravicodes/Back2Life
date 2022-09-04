//
//  EnterOTPViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit

class EnterOTPViewController: MainBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var otpTextfield: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var didntReceivedCodeButton: UIButton! {
        didSet {
            didntReceivedCodeButton.setAttributedTitle(retryTitle, for: .normal)
        }
    }
    
    // MARK: - Properties
    
    lazy var retryTitle: NSAttributedString = {
        var text: NSMutableAttributedString = NSMutableAttributedString()
        text.append(NSAttributedString(string: "Keinen Code erhalten?", attributes: [NSAttributedString.Key.font: AppFont.font(style: AppFont.Poppins.medium, size: 14), NSAttributedString.Key.foregroundColor: AppColor.secondaryLabelColor]))
        text.append(NSAttributedString(string: " "))
        text.append(NSAttributedString(string: "Hier klicken", attributes: [NSAttributedString.Key.font: AppFont.font(style: AppFont.Poppins.bold, size: 14), NSAttributedString.Key.foregroundColor: AppColor.primaryLabelColor]))
        return text
    }()
    
    var router : HTTPRequest<AuthenticationEndPoint>?
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberLabel.text = UserStoreSingleton.shared.phoneNumer
        otpTextfield.text = String(UserStoreSingleton.shared.OtpCode!)
        router = HTTPRequest<AuthenticationEndPoint>()
       // addMidleLogoView()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func verificationButtonAction(_ sender: Any) {
        verifyOtp()
       // self.navigate(.home)
    }
    
    @IBAction func resendOtpAction(_ sender: Any) {
        resendOtpApi()
    }
   
    // MARK: - Additional Helpers
    func verifyOtp(){
        let params : [String:Any] = ["phone": UserStoreSingleton.shared.phoneNumer ?? "","otp": otpTextfield.text!]
        self.showActivity()
        router?.request(.verifyOtp(params), type: VerifyOtpModel.self, completion: { (response) in
            self.hideActivity()
            switch response{
            case .success(let data):
                if data.status ?? 0 == 400{
                    self.showMessage(data.message ?? "Something went wrong")
                }else if data.status ?? 0 == 201{
                    self.showMessage(data.message ?? "")
                }else{
                    UserStoreSingleton.shared.userToken = data.data?.token
                //    self.navigate(.home)
                    self.navigate(.profile(isFromHome: false))
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
        })
    }
    
    func resendOtpApi(){
        let params : [String:Any] = ["phone": UserStoreSingleton.shared.phoneNumer ?? ""]
        self.showActivity()
        router?.request(.resendOtp(params), type: ResendOtpModel.self, completion: { (response) in
            self.hideActivity()
            switch response{
            case .success(let data):
                if data.status ?? 0 == 401{
                    self.showMessage(data.message)
                }else if data.status ?? 0 == 201{
                    self.showMessage(data.message)
                }else{
                   // UserStoreSingleton.shared.OtpCode = data.body.otp
                    self.otpTextfield.text = String(data.body.otp)
                  //  self.navigate(.home)
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
        })
    }
    
  
}
