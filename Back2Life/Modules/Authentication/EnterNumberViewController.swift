//
//  EnterNumberViewController.swift
//  Back2Life
//
//  Created by Bright on 19/05/21.
//

import UIKit
import Designable

class EnterNumberViewController: MainBaseViewController {
    
    @IBOutlet weak var txt_CountryCode: UITextField!
    @IBOutlet weak var view_CountryOptions: UIView!
    @IBOutlet weak var numberTextfield: UITextField!
    @IBOutlet weak var codeView: DesignableView!
    
    @IBOutlet weak var submitButton: DesignableButton!
    var router : HTTPRequest<AuthenticationEndPoint>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextfield.setLeftPaddingPoints(15)
        router = HTTPRequest<AuthenticationEndPoint>()
        codeView.roundedCorners(corners: [.leftTop, .leftBottom], with: 30)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        addImageNav()
        // addLeftNavMenuButton()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                navigate(.enterOTP)
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
                
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func loginApi() {
        let countryCode = txt_CountryCode.text ?? ""
        let phoneNumber = numberTextfield.text ?? ""
        let phoneCountryCode = "\(countryCode)\(phoneNumber)"
        let params = ["phone" : phoneCountryCode]
        UserStoreSingleton.shared.phoneNumer = phoneCountryCode
        //  self.showActivity()
        submitButton.isUserInteractionEnabled = false
        router?.request(.login(params), type: LoginModel.self, completion: { (response) in
            // self.hideActivity()
            switch response{
            case .success(let data):
                self.showMessage(data.message ?? "")
                UserStoreSingleton.shared.OtpCode = data.data?.otp
                if data.status ?? 0 == 200{
                    self.submitButton.isUserInteractionEnabled = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "EnterOTPViewController") as! EnterOTPViewController
                        
                        let navigationController = self.navigationController
                        //vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: vc, action: nil)
                        
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                        transition.type = CATransitionType.moveIn
                        transition.subtype = CATransitionSubtype.fromTop
                        navigationController?.view.layer.add(transition, forKey: nil)
                        navigationController?.pushViewController(vc, animated: false)
                    }
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
        })
    }
    
    @IBAction func btn_Options(_ sender: UIButton) {
        view_CountryOptions.isHidden = false
    }
    
    @IBAction func btn_CountryOption(_ sender: UIButton) {
        
        if sender.tag == 91 {
            txt_CountryCode.text = "+91"
        }
        else {
            txt_CountryCode.text = "+49"
        }
        view_CountryOptions.isHidden = true
        
    }
    
    
    @IBAction func NextAction(_ sender: Any) {
        if numberTextfield.text?.isEmptyOrWhitespace() ?? true{
            self.showMessage(str_EmptyPhone)
            return
        }
        else if numberTextfield.text?.count ?? 0 < 10 {
            self.showMessage(str_ValidPhone)
            return
        }
        else{
            loginApi()
        }
    }
    
    
}

extension EnterNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return range.location < 12 //Here 10 is your character limit
    }
}


