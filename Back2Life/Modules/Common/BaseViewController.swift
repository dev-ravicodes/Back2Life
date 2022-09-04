//
//  BaseViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift

class BaseViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var navigationController: BaseNavigationViewController? {
        return super.navigationController as? BaseNavigationViewController
    }
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    // MARK: - Additional Helpers
    func showActivity() {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30), type: .circleStrokeSpin, color: .black, backgroundColor: UIColor(named: "AppColor"))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func showMessage(_ withMessage : String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.cornerRadius = 5.0
        style.backgroundColor = .black
        style.messageFont = UIFont.boldSystemFont(ofSize: 15.0)
        self.view.clearToastQueue()
        self.view.makeToast(withMessage, duration: 2.0, position: .top, style: style)
    }
    func getConsumerProfile(_ completion : @escaping(_ : UserData?) -> Void){
        let router = HTTPRequest<AuthenticationEndPoint>()
        self.showActivity()
        router.request(.getConsumer, type: UserProfileModel.self) { (response) in
            self.hideActivity()
            switch response{
            case .success(let model):
                UserStoreSingleton.shared.name = model.data?.name ?? ""
                UserStoreSingleton.shared.phoneNumer = model.data?.phone ?? ""
                completion(model.data)
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
            
        }
    }
    // MARK: - Additional Helpers
    func uploadprofileImage(image : UIImage,_ completion : @escaping(_ : String?) -> Void){
        let router = HTTPRequest<AuthenticationEndPoint>()
        let profileImageData = image.jpegData(compressionQuality: 0.1)
        let param: Parameters = [:]
        let uploadableFile = UploadableFile(type: UploadableFile.FileType.image, data: profileImageData!, param: "image")
        router.request(AuthenticationEndPoint.uploadFile(param), type: UploadImageModel.self, file: uploadableFile) { (result) in
            print(result)
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            case .success(let data):
                print(data)
                if let image = data.data?.image{
                    completion(image.first ?? "")
                }else{
                    completion(nil)
                }
            }
        }
    }
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.prefix(maxLength).description
    }
}

