//
//  PayByCardViewController.swift
//  Back2Life
//
//  Created by Sachin Kumar on 21/05/21.
//  Copyright © 2021 Sachin Kumar. All rights reserved.
//

import UIKit
import Stripe
import AFNetworking
import Designable
import Toast_Swift
import Braintree

class PayByCardViewController: MainBaseViewController,UITextFieldDelegate, STPPaymentCardTextFieldDelegate, BTViewControllerPresentingDelegate {
    
    var bookingConfirm = "ComeFrom"
    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var backButton: UIButton!
    
    @IBOutlet weak var btn_Pay: DesignableButton!
    @IBOutlet weak var view_Ammount: UIView!
    var view_LayOver = UIView()
    @IBOutlet weak var view_Message15Min: UIView!
    @IBOutlet weak var eurPrice: UILabel!
    @IBOutlet weak var ccNumberTextField
        : UITextField!
    @IBOutlet weak private var zahlenButton: UIButton!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var yearTextfield: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var cvvtextField: UITextField!
    @IBOutlet weak var monthTableView: UITableView!
    @IBOutlet weak var timePopUp: UIView!
    @IBOutlet weak var customdate: UIView!
    
    @IBOutlet weak var paymentButton: DesignableButton!
    @IBOutlet weak var cardViews: STPPaymentCardTextField!
    
    let paymentTextField = STPPaymentCardTextField()
    var isPaypalSelected = false
    var braintreeClient: BTAPIClient!
    
    var date: Int!
    var stripeToken: String?
    var paymentStatus: String?
    var TransactionStatus: String?
    var router : HTTPRequest<AuthenticationEndPoint>?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPaypalSelected = UserStoreSingleton.shared.isPayPal ?? false
        if isPaypalSelected {
            view_LayOver.frame = CGRect(x: 0, y: 110, width: self.view.frame.width, height: 400)
            self.braintreeClient = BTAPIClient(authorization: "sandbox_q7p5ss9c_kqrtdhkwdhyvbs98")
            customPayPalButtonTapped()
            view_LayOver.backgroundColor = .white
            self.view.addSubview(view_LayOver)
        }
        else {
            paymentTextField.frame = CGRect(x: 0, y: 18, width: self.cardViews.frame.width, height: 55)
            paymentTextField.delegate = self
            cardViews.addSubview(paymentTextField)
        }
        
        
        paymentTextField.postalCodeEntryEnabled = false
        customdate.isHidden  = true
        eurPrice.text? = (UserDefaults.standard.value(forKey: "ERO") as? String ?? "") + " €"
        paymentButton.setTitle((UserDefaults.standard.value(forKey: "ERO") as? String ?? "") + " € ZAHLEN", for: .normal)
        router = HTTPRequest<AuthenticationEndPoint>()
        self.view.backgroundColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        textField.inputView = datePicker
        customdate.isHidden = false
    }
    
    @IBAction func openYear(_ sender: Any) {
        customdate.isHidden = false
        
    }
    
    
    // MARK: Helper Methods
    func closekeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
    }
    
    private func getToken() {
        let cardParams = STPCardParams()
        
        if cardHolderNameTextField.text == "" {
            showMessage(str_EpmtyCardHolderName)
            return
        }
        guard let cardNumber = paymentTextField.cardNumber else {
            showMessage(str_EpmtyCardNumber)
            return
        }
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(paymentTextField.expirationMonth)
        cardParams.expYear = UInt(paymentTextField.expirationYear)
        
        guard let cvc = paymentTextField.cvc else {
            showMessage(str_EpmtyCVVNumber)
            return
        }
        cardParams.cvc = cvc
        
        // Pass it to STPAPIClient to create a Token
        STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
            guard let token = token else {
                // Handle the error
                return
            }
            let tokenID = token.tokenId
            print(tokenID)
            
            self.stripeToken = tokenID
            self.stripeChargesApi()
            
        }
        
    }
    
    @IBAction func SubmitAction(_ sender: Any) {

        if isPaypalSelected {
            customPayPalButtonTapped()
        }
        else {
            if stripeToken == "" {
                let alert = UIAlertController(title: "Back2Life", message: "Enter Payment Details", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        print("default")
                        
                        case .cancel:
                        print("cancel")
                        
                        case .destructive:
                        print("destructive")
                        
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                getToken()
            }
        }
    }
    
    
    func handleError(error: NSError) {
        print(error)
        UIAlertView(title: str_PleaseTryAgain,
                    message: error.localizedDescription,
                    delegate: nil,
                    cancelButtonTitle: "OK").show()
    }
    
    func savePaymentApi(transaction_id: String, transaction_type: String, transaction_status: String) {
        let money = UserDefaults.standard.value(forKey: "ERO") as? String
        let Amount = money?.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        let params = ["order_id":UserStoreSingleton.shared.order_id ?? 0 ,
                      "transaction_id":transaction_id ,
                      "transaction_type":transaction_type,
                      "transaction_status":TransactionStatus ?? "","transaction_amount": Amount ?? ""] as [String : Any]
        self.showActivity()
        router?.request(.savePayment(params), type: SavePayment.self, completion: { (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let data):
                print(data.message ?? "")
                self.showMessage(data.message ?? "")
                if data.status ?? 0 == 200{
                    UserDefaults.standard.removeObject(forKey: "ERO")
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                        self.view_LayOver.isHidden = true
                        self.view_Message15Min.isHidden = false
                        //self.navigate(.qrbutton)
                    }
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
        })
    }
    @IBAction func btn_Continue15Min(_ sender: UIButton) {
        self.view_Message15Min.isHidden = true
        //self.navigate(.qrbutton)
        self.navigate(.home)
    }
    
    func stripeChargesApi() {
        showActivity()
        let money = UserDefaults.standard.value(forKey: "ERO") as? String
        let Amount = money?.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        let parameters : [String: Any] =  ["amount":Amount ?? "",
                                           "source":stripeToken ?? "",
                                           "currency":"eur"]
        
        let postData = parameters.percentEncoded()
        
        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/charges")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer sk_test_51JCLMyHh3ZULRx65OSYIbPrAhjqyOaOvCndsIiICJvZX0jqtjcWxE4EHPg8E6dXnG9M0bOsaELqm4UpirIoeYJAh00948ptNbt", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        let dataTask = URLSession.shared.dataTask(with: request) {
                data,response,error in
            self.hideActivity()
                guard let data = data else {
                   
                    return
                }
                do {
                    let data = try JSONDecoder().decode(StripeTokenModel.self, from: data)
                    DispatchQueue.main.async {
                        print(data)
                        let getSuccess = data.status
                        
                        print(getSuccess)
                        if data.paid ==  true{
                            self.TransactionStatus = "Success"
                            self.paymentStatus = data.id
                            
                            self.savePaymentApi(transaction_id: self.paymentStatus ?? "", transaction_type: "card", transaction_status: self.TransactionStatus ?? "")
                        }else{
                            self.TransactionStatus = "Fail"
                            self.hideActivity()
                        }
                    }
                } catch let error {
                    debugPrint(error.localizedDescription)
                }

            }
            dataTask.resume()
    }
}

extension UITextField{
    @IBInspectable var placeholderColor: UIColor {
        get {
            return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .lightText
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: newValue])
        }
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension PayByCardViewController {
    func customPayPalButtonTapped() {
        showActivity()
        let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
        let amount = "1.00"//UserDefaults.standard.value(forKey: "ERO") as? String ?? ""
        let request = BTPayPalCheckoutRequest(amount: amount)
        // or let request = BTPayPalVaultRequest()

        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
            
            self.hideActivity()
            guard let tokenizedPayPalAccount = tokenizedPayPalAccount else {
                if let error = error {
                    // Handle error
                } else {
                    // User canceled
                }
                return
            }
            print("Got a nonce! \(tokenizedPayPalAccount.nonce)")
            self.TransactionStatus = "Success"
            self.savePaymentApi(transaction_id: "\(tokenizedPayPalAccount.nonce)", transaction_type: "paypal", transaction_status: self.TransactionStatus ?? "")
            
            
            if let address = tokenizedPayPalAccount.billingAddress {
                print("Billing address:\n\(address.streetAddress)\n\(address.extendedAddress)\n\(address.locality) \(address.region)\n\(address.postalCode) \(address.countryCodeAlpha2)")
            }
        }
    }
    // MARK: - BTViewControllerPresentingDelegate
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - BTAppSwitchDelegate
    // Optional - display and hide loading indicator UI
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
       // showLoadingUI()

       // NotificationCenter.default.addObserver(self, selector: #selector(hideLoadingUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
       // hideLoadingUI()
    }
}

