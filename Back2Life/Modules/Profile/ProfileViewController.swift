//
//  ProfileViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 14/05/21.
//

import UIKit
import Designable
import Kingfisher

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var img_User: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var imageButton: DesignableButton!
    @IBOutlet weak var stateTextField: UITextField!
    
    // MARK: - Properties
    
    func addImageNav() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 253, height: 100))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "back_to_life_logo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    private lazy var middleLogoView: DesignableImageView = {
        var view: DesignableImageView = DesignableImageView()
        view.image = UIImage(named: "back2")
        view.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.height).multipliedBy(1 / 0.39)
        }
        return view
    }()
    
    var router : HTTPRequest<AuthenticationEndPoint>?
    var imagePicker : ImagePicker? = nil
    var imageUrl = ""
    var isFromHome = false
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.titleView = middleLogoView
        addImageNav()
        router = HTTPRequest<AuthenticationEndPoint>()
        UpdatecustomerProfileDetails()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        phoneNumberTextField.text = UserStoreSingleton.shared.phoneNumer
        phoneNumberTextField.isEnabled = false
        self.getConsumerProfile { (data) in
            if let userData = data{
                self.nameTextField.text = userData.name ?? ""
                self.addressTextField.text = userData.address ?? ""
                self.phoneNumberTextField.text = userData.phone ?? ""
                self.postCodeTextField.text = userData.pin_code ?? ""
                self.stateTextField.text = userData.state ?? ""
                self.imageUrl = userData.photo ?? ""
                
                UserStoreSingleton.shared.PostalCode = userData.pin_code ?? ""
                UserStoreSingleton.shared.Address = userData.address ?? ""
                UserStoreSingleton.shared.cityState = userData.state ?? ""
                UserStoreSingleton.shared.name = userData.name ?? ""
                
                DispatchQueue.main.async {
                    let url = URL(string: userData.photo ?? "")
                    self.img_User.kf.setImage(with: url, placeholder: UIImage(named: "user"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
        }
        
        if !isFromHome {
            let navButton = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: nil)
            navButton.tintColor = .white
            navigationItem.leftBarButtonItem = navButton
        }
        
        
    }
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func nextButtonAction(_ sender: Any) {
        for tf in self.getTextfield(view: self.view){
            if tf.text?.isEmptyOrWhitespace() ?? true{
                self.showMessage("Field cannot be empty")
                return
            }
        }
        if imageUrl == ""{
            self.showMessage("Upload profile picture")
            return
        }
        customerProfile()
    }
    
    @IBAction func selectPicture(sender: AnyObject) {
        self.imagePicker?.present(from: self.view)
    }
    
    
    // MARK: - Additional Helpers
    func UpdatecustomerProfileDetails(){
        let params : [String:Any] = ["fcm_token": UserStoreSingleton.shared.fcmToken ?? "","consumer_lat": UserStoreSingleton.shared.currentLat,"consumer_long": UserStoreSingleton.shared.currentLong]
        self.showActivity()
        router?.request(.saveCustomerProfile(params), type: CustomerProfilePost.self, completion: { (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let data):
                if data.status ?? 0 == 200{
                   
                }else{
                    self.showMessage(data.message ?? "")
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
        })
    }

    //MARK:- ConsumerProfile Add
    func customerProfile(){
        let params : [String:Any] = ["name":nameTextField.text ?? "" ,"address": addressTextField.text ?? "","pin_code":postCodeTextField.text ?? "","state":stateTextField.text ?? "","id_card":"" ,"photo":self.imageUrl,"date":"","time":"","fcm_token": UserStoreSingleton.shared.fcmToken ?? "","consumer_lat": UserStoreSingleton.shared.currentLat,"consumer_long": UserStoreSingleton.shared.currentLong]
        self.showActivity()
        router?.request(.saveCustomerProfile(params), type: CustomerProfilePost.self, completion: { (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let data):
                if data.status ?? 0 == 200{
                    UserStoreSingleton.shared.isLoggedIn = true
                    self.navigate(.home)
                }else if data.status ?? 0 == 201{
                    self.showMessage(data.message ?? "")
                }else{
                    self.showMessage(data.message ?? "")
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
        })
    }
}


extension ProfileViewController : ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        if let _img = image{
            self.imageButton.setImage(_img, for: .normal)
            self.showActivity()
            self.uploadprofileImage(image: _img) { (imgUrl) in
                self.hideActivity()
                self.imageUrl = imgUrl ?? ""
            }
        }
    }
}
