//
//  ViewController.swift
//  Back2Life
//
//  Created by Sachin Kumar on 18/05/21.
//  Copyright © 2021 Sachin Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import DropDown
import Designable
//import CalendarKit

class BookAppointmentViewController: MainBaseViewController, UIActionSheetDelegate, ImagePickerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    let datePicker = UIDatePicker()
    
    enum PickerIndex {
        case geburtsdatumButton
        case mittwochButton
    }
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak var userListTableview: SelfSizedTableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_Upload: UIButton!
    @IBOutlet weak var view_BookingTesterConfirm: UIView!
    @IBOutlet weak var img_BarCode: UIImageView!
    @IBOutlet weak var lbl_Termin: UILabel!
    @IBOutlet weak var lbl_Header: UILabel!
    @IBOutlet weak var view_24HourConfirmation: UIView!
    @IBOutlet weak var view_Checkout: UIView!
    @IBOutlet weak private var backButton: UIButton!
    @IBOutlet weak var datePickerNew: UIDatePicker!
    @IBOutlet weak var userStackView: UIStackView!
    @IBOutlet weak var germanDatePicker: UIDatePicker!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var postCodeTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var idDataTextfield: UITextField!
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak private var dateView: UIView!
    @IBOutlet weak var timeTextfield: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak private var sofortButton: UIButton!
    @IBOutlet weak private var buchenButton: UIButton!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak private var nextTextFeild: UITextField!
    @IBOutlet weak var sofortView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var geburtsButton: UIButton!
    @IBOutlet weak var IdImage: UIImageView!
    @IBOutlet weak var uploadOrderIdBtn: UIButton!
    @IBOutlet weak var firstNameStack: UIStackView!
    @IBOutlet weak var uploadOrderIdStack: UIStackView!
    @IBOutlet weak var orderIdViewline: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet var AddNewUser: DesignableButton!
    @IBOutlet weak var removeUserButton: UIButton!
    
    
    //MARK: - Properties
    var router : HTTPRequest<AuthenticationEndPoint>?
    private let timePicker = UIDatePicker()
    var consumerScreenResponse : [getPostData]?
    var arrGetOrderListing : [orderListingData]?
    var imagePicker: ImagePicker? = nil
    var testData = [String:Any]()
    var isFreeTest = false
    var isFromTestKit = false
    var Price: String?
    var imageUrl = ""
    var serverDate = ""
    var persontestValue: Int?
    var userValue = 0
    var nameList: [String] = []
    var nameArray: [String] = []
    var imageArray: [UIImage] = []
    var userount: Int?
    var arrUserList : NSMutableArray = NSMutableArray()
    var iCurrentIndexSelected : Int = 0
    var bIsUploadIdSelected : Bool = false
    var arrOrderId : [UploadOrderIDDropDown] = []
    var typeList = NSArray()
    let dropDown = DropDown()
    var OrderId: Int = 0
    var KitCount: Int?
    var date: Date = Date()
    var kitsName: String?
    var allKits: [String] = []
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let loc = Locale(identifier: "zh-CN")
        self.datePicker.locale = loc
        var calander = Calendar.current
        calander.locale = loc
        self.datePicker.calendar = calander
        self.datePicker.locale = loc
        if #available(iOS 15.0, *) {
            date.formatted(.dateTime.month(.wide).locale(.init(identifier: "zh-CN")))
        } else {
            // Fallback on earlier versions
        }
        datePicker.minuteInterval = 10
        if userount == nil{
            AddNewUser.isHidden = true
            removeUserButton.isHidden = true
        }
        self.tableviewHeight.constant = 0
        router = HTTPRequest<AuthenticationEndPoint>()
        userListTableview.delegate = self
        userListTableview.dataSource = self
        let name1 = UserStoreSingleton.shared.name
        nameArray.append(name1!)
        sofortView.isHidden = true
        dateView.isHidden = true
        firstNameStack.isHidden = true
        viewLine.isHidden = true
        nameTextfield.delegate = self
        if isFreeTest == true {
            let price = testData["Price"] as? String
            let persontest = testData["Price"] as? String
            nameTextfield.isHidden = false
            print(persontest!)
            print(price ?? "")
        }else{
            if isFromTestKit {
                firstNameStack.isHidden = false
                uploadOrderIdStack.isHidden = true
                orderIdViewline.isHidden = true
                viewLine.isHidden = false
                self.tableviewHeight.constant = 0
                let price = testData["Price"] as? String
                print(price ?? "")
                let fullNameArr = price?.components(separatedBy: " ")
                UserDefaults.standard.setValue(fullNameArr?[0] ?? "", forKey: "ERO")
                persontestValue = testData["Id"] as? Int
                persontestValue = 0
                print(persontestValue ?? 0)
                //                if persontestValue == 2 {
                //                    secondStack.isHidden = false
                //                    thirdStack.isHidden = true
                //                }else  if persontestValue == 3 {
                //                    secondStack.isHidden = false
                //                    thirdStack.isHidden = false
                //                }else{
                //                    nameTextfield.isHidden = false
                //                }
                
//                let splitValue = price?.split(separator: "€")
//                let sepratorValue = price?.replacingOccurrences(of: ",", with: "")
//                let removeEro = sepratorValue?.replacingOccurrences(of:"€", with: "")
//                let removeSpace = removeEro?.trimmingCharacters(in: .whitespaces)
//                Price = removeEro
           //     UserDefaults.standard.setValue(removeSpace, forKey: "ERO")
            }
            
            
        }
        imagePicker = ImagePicker(presentationController: self, delegate: self)
     //   self.dateTextfield.setInputViewDatePicker(target: self, selector: #selector(doneAction), withmode: .date)
        self.dateTextfield.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(doneAction), datePickerMode: .date)
        datePicker.minuteInterval = 10
       // self.timeTextfield.setInputViewDatePicker(target: self, selector: #selector(timedoneAction), withmode: .time, TimeInterval: 10)
       // self.timeTextfield.datePicker(target: self, doneAction: #selector(timedoneAction), cancelAction: #selector(timedoneAction))
        self.timeTextfield.datePicker(target: self, doneAction: #selector(timedoneAction), cancelAction: #selector(timedoneAction), datePickerMode: .time)
       // self.timeTextfield.setInputViewDatePicker(target: self, selector: #selector(timedoneAction), withmode: .time )
        addressTextfield.isUserInteractionEnabled = true
        
        if isFromTestKit {
            cityTextField.text = UserStoreSingleton.shared.cityState
            nameTextfield.text = UserStoreSingleton.shared.name
            postCodeTextfield.text = UserStoreSingleton.shared.PostalCode
            addressTextfield.text = UserStoreSingleton.shared.Address
            phoneNumberTextField.text = UserStoreSingleton.shared.phoneNumer
        }
        else {
            //  btn_Upload.setTitle("Testkit-Barcode hochladen", for: .normal)
            getOrderListing()
            lbl_Termin.text = "Online Termin vereinbaren"
            view_Checkout.isHidden = true
            lbl_Header.text = "Online Termin vereinbaren"
            cityTextField.text = UserStoreSingleton.shared.cityState
            nameTextfield.text = UserStoreSingleton.shared.name
            postCodeTextfield.text = UserStoreSingleton.shared.PostalCode
            addressTextfield.text = UserStoreSingleton.shared.Address
            phoneNumberTextField.text = UserStoreSingleton.shared.phoneNumer
            
            let tap = UITapGestureRecognizer(target: self,action: #selector(handleTaponTextField(_:)))
            tap.numberOfTapsRequired = 1
            tap.delegate = self
//            addressTextfield.addGestureRecognizer(tap)
//            self.locationManager = LocationManager(controller: self, locationDelegate: self)
        }
        
        
    }

    
    @IBAction func uploadOrderIdAction(_ sender: Any) {
        
//        var arrMsg : [String] = []
//
//        for obj in self.arrOrderId
//        {
//            arrMsg.append(obj.strShowOrderId)
//        }
        dropDown.dataSource = allKits
        dropDown.anchorView = uploadOrderIdBtn //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (uploadOrderIdBtn).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            DispatchQueue.main.async {
                self?.uploadOrderIdBtn.setTitle(item, for: .normal)
                //9
                self?.kitsName = item
                if index < self?.arrOrderId.count ?? 0
                {
                    let obj : UploadOrderIDDropDown = self?.arrOrderId[index] as! UploadOrderIDDropDown
                    self?.OrderId = obj.iOrderID
                    self?.KitCount = obj.iNumberOfKits
                    self?.arrUserList.removeAllObjects()
                    self?.userount = 1
                    self?.arrUserList.add(UserListDetailBook())
                    self?.AddNewUser.isHidden = false
                    self?.removeUserButton.isHidden = false
                    if self?.userount == self?.KitCount{
                        self?.AddNewUser.isHidden = true
                        self?.removeUserButton.isHidden = true
                    }
//                    switch obj.iNumberOfKits {
//                    case 1:
//                        self?.userount = 1
//                        self?.arrUserList.add(UserListDetailBook())
//                        break
//
//                    case 5:
//                        self?.userount = 5
//                        for _ in 0..<5
//                        {
//                            self?.arrUserList.add(UserListDetailBook())
//                        }
//                        break
//
//                    case 10:
//                        self?.userount = 10
//                        for _ in 0..<10
//                        {
//                            self?.arrUserList.add(UserListDetailBook())
//                        }
//                        break
//
//                    case 20:
//                        self?.userount = 20
//                        for _ in 0..<20
//                        {
//                            self?.arrUserList.add(UserListDetailBook())
//                        }
//                        break
//
//                    default:
//                        break
//                    }
                }
                self?.userCounts()
                self?.userListTableview.reloadData()
            }
        }
       
    }
    
    func userCounts(){
        if userount == 1{
            self.tableviewHeight.constant = 150
            self.userListTableview.layoutIfNeeded()
        }else if userount == 2{
            self.tableviewHeight.constant = 300
            self.userListTableview.layoutIfNeeded()
        }else if userount == 3{
            self.tableviewHeight.constant = 450
            self.userListTableview.layoutIfNeeded()
        }else if userount == 4{
            self.tableviewHeight.constant = 600
            self.userListTableview.layoutIfNeeded()
        }else if userount == 5{
            self.tableviewHeight.constant = 750
            self.userListTableview.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextfield {
            let name1 = nameTextfield.text!
            nameArray.append(name1)
            
            print(nameArray)
        }else{
            if textField.tag >= 1000
            {
                let iCurrentIndex : Int = textField.tag%1000
                
                if iCurrentIndex < self.arrUserList.count
                {
                    iCurrentIndexSelected = iCurrentIndex
                    
                    var obj : UserListDetailBook = self.arrUserList.object(at: iCurrentIndexSelected) as! UserListDetailBook
                    
                    obj.strUserName = textField.text!
                    
                    self.arrUserList.replaceObject(at: iCurrentIndexSelected, with: obj)
                    
                    self.userListTableview.reloadData()
                }
            }
            //end.
        }
        
    }
    
    @IBAction func removeUserAction(_ sender: UIButton) {
        userount = 0
        self.tableviewHeight.constant = 0
        userListTableview.reloadData()
        
        print(KitCount)
        if userount == KitCount{
            AddNewUser.isHidden = true
            removeUserButton.isHidden = true
            return
        }else{
        
        userount = (userount! - 1)
            self.arrUserList.remove(UserListDetailBook())
        self.userCounts()
        self.userListTableview.reloadData()
        if userount == 5{
            AddNewUser.isHidden = true
            removeUserButton.isHidden = true
        }
      }
    }
    
    @IBAction func newUser_AddAction(_ sender: Any) {
        print(KitCount)
        if userount == KitCount{
            AddNewUser.isHidden = true
            removeUserButton.isHidden = true
            return
        }else{
        
        userount = (userount! + 1)
        self.arrUserList.add(UserListDetailBook())
        self.userCounts()
        self.userListTableview.reloadData()
        if userount == 5{
            AddNewUser.isHidden = true
            removeUserButton.isHidden = true
        }
      }
    }
    
    
    @objc func handleTaponTextField(_ sender: UITapGestureRecognizer) {
        let vc = storyboard?.instantiateViewController(identifier: "PickUpVC") as! PickUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let vc = storyboard?.instantiateViewController(identifier: "PickUpVC") as! PickUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc
    func doneAction() {
        if let datePickerView = self.dateTextfield.inputView as? UIDatePicker {
            self.dateTextfield.text = datePickerView.date.toGermanString()
            self.serverDate = datePickerView.date.toServerString()
            self.dateTextfield.resignFirstResponder()
        }
    }
    
    @objc
    func timedoneAction() {
        if let datePickerView = self.timeTextfield.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "de_DE")
            datePicker.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.timeTextfield.text = dateString
            print(dateString)
            self.timeTextfield.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.postCodeTextfield.text = UserStoreSingleton.shared.PostalCode
        //self.addressTextfield.text = UserStoreSingleton.shared.Address
        sofortView.isHidden = true
    }
    
    
    //MARK: -  Interface Builder Actions
    @IBAction func sofortButtonAction(_ sender: UIButton) {
        //sofortView.isHidden = false
        consumerBookingApi(false)
    }
    
    @IBAction func sofrotHideView(_ sender: Any) {
        sofortView.isHidden = true
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        //view_BookingTesterConfirm.isHidden = false
        //consumerBookingApi(false)
    }
    
    @IBAction func chooseProfilePicBtnClicked(sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(identifier: "LicensePlatePhotoUploadViewController") as! LicensePlatePhotoUploadViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigate(.uploadKitPhoto)
        
        //self.imagePicker?.present(from: self.view)
    }
    
    @IBAction func btn_Checkout(_ sender: UIButton) {
        //view_24HourConfirmation.isHidden = false
        //self.navigate(.selectCard)
        orderTestKitApi()
    }
    @IBAction func btn_ConfirmOK(_ sender: UIButton) {
        view_24HourConfirmation.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Helpers
    
    @IBAction func languagePickerDate(_ sender: Any) {
        
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker?){
        
    }
    
    
    @objc func onDoneButtonClick() {
        datePicker.isHidden = true
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        datePicker.isHidden = true
    }
    
    
    //MARK: - Objc Methods
    
    @objc func timePickerDone() {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "de_DE")

        formatter.dateFormat = "HH:mm"
        
        var today = Date()
        print(today)
        today.addTimeInterval(10)
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 10, to: today)!
        print(modifiedDate)
        
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        let my = formatter.string(from:  timePicker.date.addingTimeInterval(20))
        nextTextFeild.text = "\(my)"
        self.view.endEditing(true)
    }
    
    
    @objc func datePickerCancel() {
        self.view.endEditing(true)
    }
    
    @objc func datePickerDoneforMitovachTextFeild() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        
        // mitovachTextFeild.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func downloadSheet(sender: AnyObject)
    {
        
        let actionsheet = UIAlertController(title: "Back2Life", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Weiblich", style: UIAlertAction.Style.default, handler: { (action) -> Void in
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Männlich", style: UIAlertAction.Style.default, handler: { (action) -> Void in
        }))
        actionsheet.addAction(UIAlertAction(title: "Stornieren", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    
    @IBAction func pymentAction(_ sender: Any) {
        bookTesterApi()
        
        
        //consumerBookingApi(true)
        // self.navigate(.selectCard)
        //  self.navigate(.qrbutton)
    }
    @IBAction func buuuu(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PickUpVC") as! PickUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Upload Id
    func didSelect(image: UIImage?) {
        if let img = image{
            IdImage.image = img
            self.uploadprofileImage(image: img) { (imgUrl) in
                self.hideActivity()
                if let url = imgUrl{
                    self.imageUrl = url
                }
            }
        }
    }
    
    //MARK:- ConsumerProfile Add
    
    func bookTesterApi(){
        ValidationTextfieled()
        
        //        if IdImage.image == nil {
        //            self.showMessage(str_ClickTestKitBarCode)
        //            return
        //        }   let params : [String:Any] = ["date": self.serverDate,"time": timeTextfield.text ?? "","name" : nameTextfield.text!,"order_id" : OrderId!,"address" : addressTextfield.text!,"postalCode" : postCodeTextfield.text!,"city" : cityTextField.text!,"phone" : phoneNumberTextField.text!,"kits_photo" : self.imageUrl]
        //"name" : nameTextfield.text!
        //"kits_photo" : self.imageUrl
        if OrderId == 0
        {
            self.showMessage(str_orderId)
         return
        }
        
        // validation check.
        for x in 0..<self.arrUserList.count
        {
            let obj : UserListDetailBook = self.arrUserList.object(at: x) as! UserListDetailBook
            
            if obj.strUserName == nil
            {
                self.showMessage(str_EmptyName)
                
             return
                
            }else
            {
                if obj.strUserName == ""
                {
                self.showMessage(str_EmptyName)
                    
                  return
                }
            }
            
            
            if obj.strUploadIDImg_URL == nil
            {
                self.showMessage(str_UploadIDImg)
                
             return
                
            }else
            {
                if obj.strUploadIDImg_URL == ""
                {
                self.showMessage(str_UploadIDImg)
                    
                  return
                }
            }
            
            if obj.strUploadKitImg_URL == nil
            {
                self.showMessage(str_UploadKitImg)
                
             return
                
            }else
            {
                if obj.strUploadKitImg_URL == ""
                {
                self.showMessage(str_UploadKitImg)
                    
                  return
                }
            }
        }
        if self.serverDate == ""
        {
            self.showMessage(str_SelectDate)
         return
        }
        if self.timeTextfield.text == ""
        {
            self.showMessage(str_SelectTime)
         return
        }
        //end.
                
                var strJsonBooking : String = ""
               let arrBookingInfo : NSMutableArray = NSMutableArray()
                
                for x in 0..<self.arrUserList.count
                {
                    let obj : UserListDetailBook = self.arrUserList.object(at: x) as! UserListDetailBook
                    
                    let dic : NSMutableDictionary = NSMutableDictionary()
                    dic.setValue(obj.strUserName!, forKey: "user_name")
                    dic.setValue(obj.strUploadIDImg_URL!, forKey: "user_id_card")
                    dic.setValue(obj.strUploadKitImg_URL!, forKey: "kits_photo")
                    dic.setValue(kitsName ?? "", forKey: "kitsname")
                    arrBookingInfo.add(dic)
                    
                }
               
                do {

                    //Convert to Data
                    let jsonData = try JSONSerialization.data(withJSONObject: arrBookingInfo, options: JSONSerialization.WritingOptions.prettyPrinted)

                    //Convert back to string. Usually only do this for debugging
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                       print(JSONString)
                        
                        strJsonBooking = JSONString
                    }

                   
                } catch {
                    print(error.localizedDescription)
                }
                 print(self.serverDate)
        let params : [String:Any] = ["booking_info":strJsonBooking,"date": self.serverDate,"time": timeTextfield.text ?? "","order_id" : OrderId,"address" : addressTextfield.text!,"postalCode" : postCodeTextfield.text!,"city" : cityTextField.text!,"phone" : phoneNumberTextField.text!,"latitude":UserStoreSingleton.shared.currentLat ?? 0.0,"longitude":UserStoreSingleton.shared.currentLong ?? 0.0,"kitsname": kitsName ?? ""]
        UserStoreSingleton.shared.kitsName = kitsName
        print(params)
        self.showActivity()
        router?.request(.bookTester(params), type: BookingPost.self, completion: { (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let data):
                if data.status ?? 0 == 200{
                    print(data)
                    
                   // self.img_BarCode.image = self.IdImage.image
                    
                    let navButton = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: nil)
                    navButton.tintColor = .white
                    self.navigationItem.leftBarButtonItem = navButton
                    self.view_BookingTesterConfirm.isHidden = false
                    
//                    if data.status == 200{
//                        let aC = UIAlertController(title: "Back2Life", message: data.message ?? "", preferredStyle: .alert)
//                        let cancelBtn = UIAlertAction(title: "OK", style: .default) { (clicked) in
//                            aC.dismiss(animated: true, completion: nil)
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                        aC.addAction(cancelBtn)
//                        self.present(aC, animated: true, completion: nil)
//                      //  self.showMessage(data.message ?? "")
//                    }
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
    
    
    func orderTestKitApi(){
        //ValidationTextfieled()
        if nameTextfield.text == "" {
            self.showMessage(str_EmptyName)
            return
        }else if addressTextfield.text == "" {
            self.showMessage(str_EmptyAddress)
            return
        }
        else if cityTextField.text == "" {
            self.showMessage(str_EmptyCity)
            return
        }
        else if postCodeTextfield.text == "" {
            self.showMessage(str_EmptyPostalCode)
            return
        }else if phoneNumberTextField.text == "" {
            self.showMessage(str_EmptyPhoneNumber)
            return
        }
        
        
        let params : [String:Any] = ["test_data": testData,"name" : nameTextfield.text!,"address" : addressTextfield.text!,"postCode" : postCodeTextfield.text!,"city" : cityTextField.text!,"phoneNumber" : phoneNumberTextField.text!,"photo" : self.imageUrl]
        
        print(params)
        self.showActivity()
        router?.request(.orderTestKit(params), type: BookingPost.self, completion: { (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let data):
                if data.status ?? 0 == 200{
                    print(data)
                    UserStoreSingleton.shared.order_id = data.data?.order_id
                    //self.navigate(.qrbutton)
                    self.navigate(.selectCard)
                    
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
    
    func ValidationTextfieled() {
        if nameTextfield.text == "" {
            self.showMessage(str_EmptyName)
            return
        }else if addressTextfield.text == "" {
            self.showMessage(str_EmptyAddress)
            return
        }
        else if cityTextField.text == "" {
            self.showMessage(str_EmptyCity)
            return
        }
        else if postCodeTextfield.text == "" {
            self.showMessage(str_EmptyPostalCode)
            return
        }
    }
    
    
    func consumerBookingApi(_ isImmediate : Bool){
        
        if persontestValue == 1 {
            ValidationTextfieled()
        }else if persontestValue == 2 {
            ValidationTextfieled()
            
        }else if persontestValue == 3 {
            ValidationTextfieled()
        }
        if IdImage.image == nil {
            self.showMessage(str_UploadId)
            return
        }
        
        if isImmediate {
            if dateTextfield.text == "" {
                self.showMessage(str_SelectDate)
                return
            }
            if timeTextfield.text == "" {
                self.showMessage(str_SelectTime)
                return
            }
        }
        
        if isFreeTest == true {
            let nameItems =  "\(nameTextfield.text ?? "")"
            let item = nameItems.split(separator: ",")
            let params : [String:Any] = ["gender": "female","name" : UserStoreSingleton.shared.name ?? "","members":item,"number" : phoneNumberTextField.text ?? "","state" : cityTextField.text ?? "","id_card" : self.imageUrl,"pin_code" : postCodeTextfield.text ?? "","address" : addressTextfield.text ?? "","photo" : self.imageUrl,"date" : isImmediate ? self.serverDate : Date().toServerString(),"time" : isImmediate ? timeTextfield.text ?? "" : Date().toTimeServerString(),"latitude":UserStoreSingleton.shared.currenBookingtLat ?? 0.0,"longitude":UserStoreSingleton.shared.currenBookingtLong ?? 0.0,"test_data": isFreeTest ? [] : [self.testData]]
            print(params)
            self.showActivity()
            router?.request(.consumerBooking(params), type: BookingPost.self, completion: { (response) in
                self.hideActivity()
                print(response)
                switch response{
                case .success(let data):
                    if data.status ?? 0 == 200{
                        print(data)
                        UserStoreSingleton.shared.bookingID = data.data?.bookingId
                        self.navigate(.qrbutton)
                        
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
        }else{
            
            var nameItems = ""
            
            if persontestValue == 1 {
                if nameTextfield.text != "" {
                    nameItems =  "\(nameTextfield.text ?? "")"
                }
            }
            //            else if persontestValue == 2 {
            //                nameItems =  "\(nameTextfield.text ?? ""),\(secondNameTextfield.text ?? "")"
            //
            //            }else if persontestValue == 3 {
            //                nameItems = "\(nameTextfield.text ?? ""),\(secondNameTextfield.text ?? ""),\(thirdNameTextfield.text ?? "")"
            //            }
            
            
            let item = nameItems.split(separator: ",")
            
            //            nameList.append(item)
            let params : [String:Any] = ["gender": "female","name" : UserStoreSingleton.shared.name ?? "","members":item,"number" : phoneNumberTextField.text ?? "","state" : cityTextField.text ?? "","id_card" : self.imageUrl,"pin_code" : postCodeTextfield.text ?? "","address" : addressTextfield.text ?? "","photo" : self.imageUrl,"date" : isImmediate ? self.serverDate : Date().toServerString(),"time" : isImmediate ? timeTextfield.text ?? "" : Date().toTimeServerString(),"latitude":UserStoreSingleton.shared.currenBookingtLat ?? 0.0,"longitude":UserStoreSingleton.shared.currenBookingtLong ?? 0.0,"test_data": isFreeTest ? [] : [self.testData]]
            print(params)
            self.showActivity()
            router?.request(.consumerBooking(params), type: BookingPost.self, completion: { (response) in
                self.hideActivity()
                print(response)
                switch response{
                case .success(let data):
                    if data.status ?? 0 == 200{
                        print(data)
                        UserStoreSingleton.shared.bookingID = data.data?.bookingId
                        self.navigate(.selectCard)
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
    
    func getOrderListing() {
        var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/get-order-listing")!,timeoutInterval: Double.infinity)
        request.addValue(UserStoreSingleton.shared.userToken ?? "", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _data = data{
                do {
                    let json = try JSONSerialization.jsonObject(with: _data) as! Dictionary<String, AnyObject>
                    print(json)
                    if let Response = json["data"] as? [[String:Any]]
                    {
                        
                        DispatchQueue.main.async { [self] in
                            
                            if Response.count > 0
                            {
                                self.userount = Response[0]["number_of_kits_remaining"] as? Int
                            }else{
                               // showAlert("please order kit first.", "Back2Life")
                                let aC = UIAlertController(title: "Back2Life", message: "please order kit first.", preferredStyle: .alert)
                                let cancelBtn = UIAlertAction(title: "OK", style: .default) { (clicked) in
                                    aC.dismiss(animated: true, completion: nil)
                                    navigationController?.popViewController(animated: true)
                                }
                                aC.addAction(cancelBtn)
                                self.present(aC, animated: true, completion: nil)
                                
                            }
                            
                            for item in Response{
                                
                                let obj : UploadOrderIDDropDown = UploadOrderIDDropDown(strShowOrderId: (String(item["id"] as! Int)) + "_1 - number_of_kits \(String(item["number_of_kits_remaining"] as! Int))", iNumberOfKits: item["number_of_kits_remaining"] as? Int ?? 0,iOrderID: item["id"] as! Int)
                                self.arrOrderId.append(obj)
                                allKits = item["all_kits_data"] as! [String]
                            }
                            print(self.arrOrderId)
                            
                        }
                    }
                } catch {
                    print("error")
                }
            }
        }
        task.resume()
    }
    //    func getOrderListing(){
    //        self.showActivity()
    //
    //        router?.request(.getOrderListing, type: GetOrderListing.self, completion: { [self] (response) in
    //            self.hideActivity()
    //            print(response)
    //          //  print(orderListingData.CodingKeys.number_of_kits)
    //
    //            switch response{
    //            case .success(let resp):
    //                print(resp)
    //                self.arrGetOrderListing = resp.data ?? [orderListingData]()
    //                self.userount = arrGetOrderListing?[0].number_of_kits
    //                self.arrOrderId = arrGetOrderListing?[]
    //                print(userount)
    //                self.userListTableview.reloadData()
    //                break
    //            case .failure(let err):
    //                self.showMessage(err.localizedDescription)
    //
    //                break
    //            }
    //        })
    //    }
    
}


extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        datePicker.locale = Locale(identifier: "de_DE")
        datePicker.minuteInterval = 10
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}


extension BookAppointmentViewController : LocationManagerDelegate{
    func currentLocation(coordinates: CLLocationCoordinate2D) {
        UserStoreSingleton.shared.currentLat = coordinates.latitude
        UserStoreSingleton.shared.currentLong = coordinates.longitude
        self.getCurrentAddress(with: coordinates) { (address) in
            self.addressTextfield.text = address
        }
    }
}
extension BookAppointmentViewController : BarCode_PhotoClick {
    func ClickImage(image: UIImage) {
            
            self.showActivity()
            self.uploadprofileImage(image: image) { (imgUrl) in
                self.hideActivity()
                
                if imgUrl != nil
                {
                    if imgUrl != ""
                    {
                if self.iCurrentIndexSelected < self.arrUserList.count
                {
                    var obj : UserListDetailBook = self.arrUserList.object(at: self.iCurrentIndexSelected) as! UserListDetailBook
                    
                    if self.bIsUploadIdSelected
                    {//upload id
                        obj.uploadIDImg = image
                        
                        obj.strUploadIDImg_URL = imgUrl
                        
                    }else
                    {//upload kit
                        obj.uploadKitImg = image
                        
                        obj.strUploadKitImg_URL = imgUrl
                    }
                    
                    self.arrUserList.replaceObject(at: self.iCurrentIndexSelected, with: obj)
                    
                    self.userListTableview.reloadData()
                }
                        
                    }else
                    {
                        self.showMessage("Please select image again.")
                    }
                }else
                {
                    self.showMessage("Please select image again.")
                }
            }
            
        }
//    func ClickImage(image: UIImage) {
//        //        imageArray.append(image)
//        //        self.IdImage.image = imageArray[0]
//        // if imageArray.indices.contains(1)
//
//        self.showActivity()
//        self.uploadprofileImage(image: image) { (imgUrl) in
//            self.hideActivity()
//
//            if self.iCurrentIndexSelected < self.arrUserList.count
//            {
//                var obj : UserListDetailBook = self.arrUserList.object(at: self.iCurrentIndexSelected) as! UserListDetailBook
//
//                if self.bIsUploadIdSelected
//                {//upload id
//                    obj.uploadIDImg = image
//
//                    obj.strUploadIDImg_URL = imgUrl
//
//                }else
//                {//upload kit
//                    obj.uploadKitImg = image
//
//                    obj.strUploadKitImg_URL = imgUrl
//                }
//
//                self.arrUserList.replaceObject(at: self.iCurrentIndexSelected, with: obj)
//
//                self.userListTableview.reloadData()
//            }
//        }
//
//    }
    
}

extension BookAppointmentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //       if userount == 5{
        //         return 5
        //       }
        //        if userount == 10{
        //           return 10
        //       }
        //        if userount == 20{
        //           return 20
        //        }
        //        else{
        //            return 1
        //        }
        return self.arrUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userListTableViewCell", for: indexPath) as? userListTableViewCell else {
            fatalError()
        }
        cell.userNameTextfield.tag = (1000 + indexPath.row)
        print(cell.userNameTextfield.tag)
        //cell.myLbl.text = array[indexPath.row]
        cell.uploadIdBtn.tag = indexPath.row
        cell.uploadKitBtn.tag = indexPath.row
        cell.uploadIdBtn.addTarget(self, action: #selector(uploadIdBtnAction(_:)), for: .touchUpInside)
        cell.uploadKitBtn.addTarget(self, action: #selector(uploadKitBtnAction(_:)), for: .touchUpInside)
        //cell.SetData(data: arrData[indexPath.row])
        if indexPath.row < self.arrUserList.count
        {
            let obj : UserListDetailBook = self.arrUserList.object(at: indexPath.row) as! UserListDetailBook
            
            if obj.uploadIDImg != nil
            {
                cell.uploadIdImage.image = obj.uploadIDImg
            }
            
            if obj.uploadKitImg != nil
            {
                cell.uploadKitImage.image = obj.uploadKitImg
            }
            
            if obj.strUserName != nil
            {
                cell.userNameTextfield.text = obj.strUserName
            }
            print(self.arrUserList)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @objc func uploadIdBtnAction(_ sender: UIButton) {
        print("I have pressed a button with a tag: \(sender.tag)")
        
        iCurrentIndexSelected = sender.tag
        bIsUploadIdSelected = true
        
        sender.isSelected.toggle()
        
        if iCurrentIndexSelected < self.arrUserList.count
        {
            let obj : UserListDetailBook = self.arrUserList.object(at: iCurrentIndexSelected) as! UserListDetailBook
            
            if obj.strUploadIDImg_URL == nil
            {
                let vc = storyboard?.instantiateViewController(identifier: "LicensePlatePhotoUploadViewController") as! LicensePlatePhotoUploadViewController
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else
            {
                // create the alert
                        let alert = UIAlertController(title: "Confirmation", message: "Do you want change image ?", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in

                    alert.dismiss(animated: true, completion: {
                    })
                    
                    let vc = self.storyboard?.instantiateViewController(identifier: "LicensePlatePhotoUploadViewController") as! LicensePlatePhotoUploadViewController
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }))

                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in

                }))
                
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc func uploadKitBtnAction(_ sender: UIButton) {
//        print("I have pressed a button with a tag: \(sender.tag)")
//
        iCurrentIndexSelected = sender.tag
        bIsUploadIdSelected = false
//
//        let vc = storyboard?.instantiateViewController(identifier: "LicensePlatePhotoUploadViewController") as! LicensePlatePhotoUploadViewController
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
//
        sender.isSelected.toggle()
        
        if iCurrentIndexSelected < self.arrUserList.count
        {
            let obj : UserListDetailBook = self.arrUserList.object(at: iCurrentIndexSelected) as! UserListDetailBook
            
            if obj.strUploadKitImg_URL == nil
            {
                let vc = storyboard?.instantiateViewController(identifier: "LicensePlatePhotoUploadViewController") as! LicensePlatePhotoUploadViewController
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else
            {
                // create the alert
                        let alert = UIAlertController(title: "Confirmation", message: "Do you want change image ?", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in

                    alert.dismiss(animated: true, completion: {
                    })
                    
                    let vc = self.storyboard?.instantiateViewController(identifier: "LicensePlatePhotoUploadViewController") as! LicensePlatePhotoUploadViewController
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }))

                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in

                }))
                
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
            }
        }
        }
}

struct UserListDetailBook
{
    var strUserName: String?
    var uploadIDImg: UIImage?
    var strUploadIDImg_URL : String?
    var iUserID: Int64?
    var uploadKitImg: UIImage?
    var strUploadKitImg_URL : String?
}

struct UploadOrderIDDropDown
{
    var strShowOrderId : String = ""
    var iNumberOfKits : Int = 0
    var iOrderID : Int = 0
}

struct BookingInfoModel
{
    var user_name : String = ""
    var user_id_card : String = ""
    var kits_photo : String = ""
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
