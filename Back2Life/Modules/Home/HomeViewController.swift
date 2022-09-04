//
//  HomeViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit
import SnapKit
import Designable
import CoreLocation
import FirebaseCrashlytics


class HomeViewController: MainBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var testAntigen: DesignableView!
    @IBOutlet weak var test2View: DesignableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var firstTestLabel: UILabel!
    
    @IBOutlet weak var secondTestLabel: UILabel!
    //@IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var reserveButton: DesignableButton!
    @IBOutlet weak var antigenTableView: UITableView!
    
    @IBOutlet weak var secondTestTableView: UITableView!
    @IBOutlet weak var testTypeLabel: UILabel!
    @IBOutlet weak var AntigenNasetestView: UIView!
    @IBOutlet weak var MainView: DesignableView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var testBottomView: UIView!
    @IBOutlet weak private var firstButton: UIButton!
    @IBOutlet weak private var secondButtton: UIButton!
    @IBOutlet weak private var thirdButtton: UIButton!
    
    @IBOutlet weak var resrvebuton2: DesignableButton!
    @IBOutlet var TesterBookView: UIView!
    
    // MARK: - Properties
    var router : HTTPRequest<AuthenticationEndPoint>?
    var welcomeScreenResponse : [welcomeData]?
    var antigenArr = NSMutableArray()
    var jsonList = NSArray()
    var typeList = NSArray()
    var paymentList = NSArray()
    var typeDict = [String:Any] ()
    var PaymentListArr = NSArray()
    var PaymentListArr2 = NSArray()
    var selectedIndex:NSIndexPath?
    
    enum BookingConfirm {
        case schedule
        case past
    }
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.isHidden = true
        TesterBookView.isHidden = true
        testAntigen.borderColor = AppColor.primaryThemeColor
        reserveButton.titleLabel?.font =  UIFont(name: "FranklinGothic-Light", size: 20)
        resrvebuton2.titleLabel?.font =  UIFont(name: "FranklinGothic-Light", size: 20)
        firstTestLabel.font =  UIFont.init(name: "FranklinGothic-Light", size: 16)
        secondTestLabel.font =  UIFont.init(name: "FranklinGothic-Light", size: 16)
        testTypeLabel.font =  UIFont.init(name: "FranklinGothic-Light", size: 18)

        testBottomView.isHidden = true
        AntigenNasetestView.isHidden = true
        antigenTableView.dataSource = self
        antigenTableView.delegate = self
        antigenTableView.rowHeight = 80
        secondTestTableView.dataSource = self
        secondTestTableView.delegate = self
        secondTestTableView.rowHeight = 80
        router = HTTPRequest<AuthenticationEndPoint>()
        addLeftNavMenuButton()
        addImageNav()
        addRightNavButtons(navItems: .profile)
        addRightNavButtons(navItems: .all)
        MainView.roundedCorners(corners: [.leftTop, .rightTop], with: 30)
        NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)

        saveCustomerProfile()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getConsumerProfile { (data) in
            
            if let userData = data{
                
                UserStoreSingleton.shared.PostalCode = userData.pin_code ?? ""
                UserStoreSingleton.shared.Address = userData.address ?? ""
                UserStoreSingleton.shared.cityState = userData.state ?? ""
                UserStoreSingleton.shared.name = userData.name ?? ""
                self.userNameLabel.text = UserStoreSingleton.shared.name ?? ""
            }
        }
        homeApi()
        if (UserDefaults.standard.value(forKey: "isSaved") != nil) {
            popUpView.isHidden = true
            testBottomView.isHidden = true
           
        }else{
            popUpView.isHidden = true
            testBottomView.isHidden = true
        }
        locationManager = LocationManager(controller: self, locationDelegate: self)
    }
    
    //MARK:- Handle Notification
    @objc func handleNotification(n : NSNotification)
    {
       print(GlobalVariable.notification_dict)
       print(GlobalVariable.notification_dict.value(forKey: "notification_type") as! String == "accept-booking")
        
        if GlobalVariable.notification_dict.value(forKey: "notification_type") as? String == "booking-report-submitted" {
            print(GlobalVariable.notification_dict.value(forKey: "result"))
            if let bookingId =  GlobalVariable.notification_dict.value(forKey: "result") {
                let str = Int(bookingId as? String ?? "0")
                print(GlobalVariable.notification_dict)
                
                let order_id = GlobalVariable.notification_dict.value(forKey: "order_id") ?? 0
                let report_id = GlobalVariable.notification_dict.value(forKey: "report_id") ?? 0
                orderId = (Int("\(order_id)") ?? 0)
                reportId = (Int("\(report_id)") ?? 0)
                navigate(.postivereport(orderId: orderId ?? 0, reportId: reportId ?? 0))
               // navigate(.postivereport(orderId: GlobalVariable.notification_dict.value(forKey: "order_id") as? Int ?? 0, reportId: GlobalVariable.notification_dict.value(forKey: "report_id") as? Int ?? 0))
            }
        }
       
    }
    // MARK: - Layout
    
    // MARK: - User Interaction2
    
    // MARK: - Additional Helpers
    
    private func showNewRequest() {
        let child = Storyboard.Test.viewController(for: NewRequestViewController.self)
        addChild(child)
        view.addSubview(child.view)
        child.view.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(8)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(8)
            make.bottom.equalToSuperview()
        }
        child.didMove(toParent: self)
    }
    
    //MARK: - Interface Builder Outlets
    
  
    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        popUpView.layer.cornerRadius = 10.0
        let buttons = [firstButton,secondButtton,thirdButtton]
        for item in buttons {
            item?.setImage(UIImage(named: "icons"), for: .normal)
            item?.setImage(UIImage(named: "iconSelected"), for: .selected)
        }
    }
    @IBAction func BookTesterAction(_ sender: Any) {
        self.navigate(.booking([:], false))
    }
    
    @IBAction func antigenNasetestAction(_ sender: Any) {
        AntigenNasetestView.isHidden = false
        popUpView.isHidden = false
    }
    
    @IBAction func AntgenAction(_ sender: Any) {
        // navigate(.chooseTest)
        testTypeLabel.text = "PoC Antigen Spucktest"
        testTypeLabel.textColor = UIColor.black
        testBottomView.isHidden = false
        testAntigen.borderColor = AppColor.primaryThemeColor
        //   test2View.borderColor = UIColor.clear
    }
    
    @IBAction func hideBottomView(_ sender: Any) {
        testBottomView.isHidden = true
    }
    
    @IBAction func firmAction(_ sender: Any) {
        testTypeLabel.text = "PoC Antigen 2cm Nasentest"
        testTypeLabel.textColor = UIColor.black
        // testAntigen.borderColor = UIColor.clear
        test2View.borderColor = AppColor.primaryThemeColor
        testBottomView.isHidden = false
    }
    
    @IBAction func testPopUp(_ sender: Any) {
        popUpView.isHidden = false
    }
    
    @IBAction func popHideButton(_ sender: Any) {
        popUpView.isHidden = true
    }
    
    @IBAction func nasetestAction(_ sender: Any) {
        testBottomView.isHidden = true
        popUpView.isHidden = false
      //  antigenTableView.isHidden = true
     //   secondTestTableView.isHidden = false
        AntigenNasetestView.isHidden = true
    }
    
    @IBAction func antigenButton(_ sender: Any) {
        testBottomView.isHidden = true
        popUpView.isHidden = true
      //  secondTestTableView.isHidden = true
        AntigenNasetestView.isHidden = false
    }
    
    @IBAction func popupAction(_ sender: Any) {
      //  navigate(.booking)
    }
    
    @IBAction func hidepopView(_ sender: Any) {
        popUpView.isHidden = true
    }
    
    @IBAction func antigenPopUpTestHide(_ sender: Any) {
        AntigenNasetestView.isHidden = true
    }
    
    @IBAction func fortsePopAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isSaved")
        navigate(.popTime)
    }
    
    
    //MARK:- getConsumerProfile
    func getConsumerProfile() {
        self.showActivity()
        router?.request(.getConsumer, type: GetCustomerProfilePost.self, completion: { [self] (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let resp):
                DispatchQueue.main.async {
                    
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                
                break
            }
        })
    }
    
    func saveCustomerProfile(){
        let params : [String:Any] = ["phone":UserStoreSingleton.shared.phoneNumer ?? "","fcmToken":UserStoreSingleton.shared.fcmToken ?? "","latitude":UserStoreSingleton.shared.currentLat ?? 0.0,"longitude":UserStoreSingleton.shared.currentLong ?? 0.0]
        self.showActivity()
        router?.request(.saveCustomerProfile(params), type: CustomerProfilePost.self, completion: { (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let data):
                if data.status ?? 0 == 200{
                    self.homeApi()
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
    
    
    func homeApi() {
        var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/welcome-screen-data")!,timeoutInterval: Double.infinity)
        request.addValue(UserStoreSingleton.shared.userToken ?? "", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _data = data{
                do {
                    let json = try JSONSerialization.jsonObject(with: _data) as! Dictionary<String, AnyObject>
                    print(json)
                    if let response = json["data"] as? [String:Any]
                    {
                        print(response)
                        DispatchQueue.main.async { [self] in
                            let HomeData = response["home_data"] as? [[String:Any]]
                            let ExtraData = response["extra_data"] as? [String:Any]
                            let ShowOrderData = ExtraData!["show_order_data"] as? Int
                            if ShowOrderData == 1 {
                                TesterBookView.isHidden = false
                            }else{
                                TesterBookView.isHidden = true
                            }
                            self.firstTestLabel.text = "PoC Antigen Spucktest"
                            self.typeList = HomeData?[0]["Type"] as! NSArray
                            typeDict = self.typeList[0] as? [String:Any] ?? [:]
                            print(self.typeDict["payment"] as! [[String:Any]])
                            PaymentListArr = self.typeDict["payment"] as! [[String:Any]] as NSArray
                            self.secondTestLabel.text = "PoC Antigen 2cm Nasentest"
                            self.typeList = HomeData?[1]["Type"] as! NSArray
                            typeDict = self.typeList[1] as? [String:Any] ?? [:]
                            print(self.typeDict["payment"] as! [[String:Any]])
                            PaymentListArr2 = self.typeDict["payment"] as! [[String:Any]] as NSArray
                            antigenTableView.reloadData()
                            secondTestTableView.reloadData()
                        }
                    }
                } catch {
                    print("error")
                }
            }
        }
        task.resume()
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == antigenTableView {
            return PaymentListArr.count
        }else if tableView == secondTestTableView{
            return PaymentListArr2.count
        }
        return PaymentListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = antigenTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeTableViewCell
        if tableView == antigenTableView {
            cell?.nameLabel?.text = (((PaymentListArr as AnyObject).object(at: indexPath.row) as! NSDictionary)["Name"] as? String)
                cell?.nameLabel.font =  UIFont.init(name: "FranklinGothic-Light", size: 16)
            cell?.amountLabel?.text = (((PaymentListArr as AnyObject).object(at: indexPath.row) as! NSDictionary)["Price"] as? String)
            cell?.checkBoxClicked = {
                //self.AntigenNasetestView.isHidden = true
               // UserDefaults.standard.set(true, forKey: "FreeTest")
                self.navigate(.booking(((self.PaymentListArr as AnyObject).object(at: indexPath.row) as? [String:Any] ?? [:]), true))
            }
            
            return cell!
        }else if tableView == secondTestTableView{
            cell?.nameLabel?.text = (((PaymentListArr2 as AnyObject).object(at: indexPath.row) as! NSDictionary)["Name"] as? String)
            cell?.amountLabel?.text = (((PaymentListArr2 as AnyObject).object(at: indexPath.row) as! NSDictionary)["Price"] as? String)
            
            cell?.nameLabel.font =  UIFont.init(name: "FranklinGothic-Light", size: 16)
            cell?.amountLabel.font =  UIFont.init(name: "FranklinGothic-Light", size: 14)
            cell?.checkBoxClicked = {
               // self.secondTestTableView.isHidden = true
                //UserDefaults.standard.set(true, forKey: "FreeTest")
          self.navigate(.booking(((self.PaymentListArr2 as AnyObject).object(at: indexPath.row) as? [String:Any] ?? [:]), true))
            }
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == antigenTableView {
            let selectValue = PaymentListArr[indexPath.row]
            print(selectValue)
          //  testdata2.add(selectValue)
            self.navigate(.booking(((self.PaymentListArr as AnyObject).object(at: indexPath.row) as? [String:Any] ?? [:]), true))
         //   print(testdata2)
          //  navigate(.booking)
        }else{
        if tableView == secondTestTableView {
            let selectValue2 = PaymentListArr2[indexPath.row]
            print(selectValue2)
            //UserDefaults.standard.set(true, forKey: "FreeTest")
            self.navigate(.booking(((self.PaymentListArr as AnyObject).object(at: indexPath.row) as? [String:Any] ?? [:]), true))
        }
        }
    
}
}


extension HomeViewController : LocationManagerDelegate{
    func currentLocation(coordinates: CLLocationCoordinate2D) {
        UserStoreSingleton.shared.currentLat = coordinates.latitude
        UserStoreSingleton.shared.currentLong = coordinates.longitude
        
        UserStoreSingleton.shared.currenBookingtLat = UserStoreSingleton.shared.currentLat
        UserStoreSingleton.shared.currenBookingtLong =  UserStoreSingleton.shared.currentLong
        
        self.getCurrentAddress(with: coordinates) { (address) in
            //self.locationLabel.text = address
        }
    }
}
