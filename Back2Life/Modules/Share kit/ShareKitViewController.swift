//
//  ShareKitViewController.swift
//  Back2Life
//
//  Created by Mohini's Mac on 09/02/22.
//

import UIKit
import Designable
import DropDown

class ShareKitViewController: MainBaseViewController, UISearchBarDelegate, UITextFieldDelegate {

    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var ShareKitTableView: UITableView!
    @IBOutlet var UserImageShared: UIImageView!
    @IBOutlet var UserNameShared: UILabel!
    @IBOutlet var SelectKit: UIButton!
    @IBOutlet var KitNUmberTxt: UITextField!
    @IBOutlet var ShareKitBtn: DesignableButton!
    
    var router : HTTPRequest<AuthenticationEndPoint>?
    var userount: Int?
    var arrOrderId : [UploadOrderIDDropDown] = []
    var typeList = NSArray()
    let dropDown = DropDown()
    var OrderId: Int = 0
    var KitCount: Int?
    var dicData = [ShareKitData]()
    var ShareKitDataFilltered = [ShareKitData]()
    var searching = false
    var SelectedUserName = ""
    var SelectedUserImage = ""
    var selectedConsumerId : Int?
    var allKits: [String] = []
    var kitsName: String?
    var kitNumber : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        router = HTTPRequest<AuthenticationEndPoint>()
        SearchBar.delegate = self
        KitNUmberTxt.delegate = self
        getOrderListing()
        getConsumerListing()
        ShareKitTableView.delegate = self
        ShareKitTableView.dataSource = self
        KitNUmberTxt.isEnabled = false
        KitNUmberTxt.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func UploadKitAction(_ sender: Any) {
        
        var arrMsg : [String] = []
        
        for obj in self.arrOrderId
        {
            arrMsg.append(obj.strShowOrderId)
        }
        dropDown.dataSource = allKits
        dropDown.anchorView = SelectKit //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (SelectKit).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            DispatchQueue.main.async {
                self?.kitsName = item
                self?.SelectKit.setTitle(item, for: .normal)
                //9
                let test = String(item.suffix(1))
                self?.KitNUmberTxt.text = test
                
                if index < self?.arrOrderId.count ?? 0
                {
                    let obj : UploadOrderIDDropDown = self?.arrOrderId[index] as! UploadOrderIDDropDown
                    
                    self?.OrderId = obj.iOrderID
                    self?.KitCount = obj.iNumberOfKits
                    self?.userount = 1
                }
            }
        }
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        kitNumber = Int(KitNUmberTxt.text!)
        }
    
    @IBAction func ShareKitAction(_ sender: Any) {
        if OrderId == 0{
            showAlert("Please Select Ordered kit first", "Alert!")
            return
        }
        if KitNUmberTxt.text == ""{
            showAlert("Please Enter Number of kits you share", "Alert!")
            return
        }
//        if kitNumber! > KitCount! {
//            showAlert("Please Enter kit amount you have", "Alert!")
//            return
//        }
        PostShareData()
    }
    
    //MARK: - Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            ShareKitTableView.isHidden = false
            ShareKitDataFilltered = dicData.filter {
               // print($0.name ?? "")
                return ($0.name ?? "").lowercased().contains(searchText.lowercased())
            }
            print(ShareKitDataFilltered)
            searching = !ShareKitDataFilltered.isEmpty
            searching = true
            self.ShareKitTableView.reloadData()
        }else {
            searching = false
            self.ShareKitTableView.reloadData()
         }
     }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.ShareKitTableView.reloadData()
    }
    
    func UpdateShareData(){
        UserImageShared.kf.setImage(with: URL(string: SelectedUserImage))
        UserNameShared.text = SelectedUserName
    }
    
    func PostShareData(){
        let params : [String:Any] = ["order_id" : OrderId, "consumer_id" : selectedConsumerId ?? 0,"number_of_kits" : "1","kitsname": kitsName ?? ""]
                print(params)
                self.showActivity()
                router?.request(.ShareKit(params), type: PostShareKitModel.self, completion: { (response) in
                self.hideActivity()
                print(response)
                switch response{
                case .success(let data):
                    if data.status ?? 0 == 200{
                        print(data)
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
                self.navigationController?.popViewController(animated: true)
        })
    }
    
    func getOrderListing(){
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
                                
                                let obj : UploadOrderIDDropDown = UploadOrderIDDropDown(strShowOrderId: (String(item["id"] as! Int)) + " - number_of_kits \(String(item["number_of_kits_remaining"] as! Int))", iNumberOfKits: item["number_of_kits_remaining"] as? Int ?? 0,iOrderID: item["id"] as! Int)
                                
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
    
    func getConsumerListing(){
        var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/get-consumer-listing")!,timeoutInterval: Double.infinity)
        request.addValue(UserStoreSingleton.shared.userToken ?? "", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _data = data{
                do {
                   // let json = try JSONSerialization.jsonObject(with: _data) as! Dictionary<String, AnyObject>
                    let json =  try JSONDecoder().decode(ShareKitModel.self, from: data ?? Data())
                    DispatchQueue.main.async {
                        print(json.data)
                        self.dicData = json.data ?? [ShareKitData]()
                        self.ShareKitTableView.reloadData()
                    }
                } catch {
                    print("error")
                }
            }
        }
        task.resume()
    }
    
}
extension ShareKitViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return ShareKitDataFilltered.count
        }
        return self.dicData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShareKitTableView.dequeueReusableCell(withIdentifier: "ShareKitTableViewCell", for: indexPath) as! ShareKitTableViewCell
        if searching {
            cell.UserImage.kf.setImage(with: URL(string: ShareKitDataFilltered[indexPath.row].photo ?? ""))
            cell.UserName.text = ShareKitDataFilltered[indexPath.row].name ?? ""
        }else{
            cell.UserImage.kf.setImage(with: URL(string: dicData[indexPath.row].photo ?? ""))
            cell.UserName.text = dicData[indexPath.row].name ?? ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            SelectedUserName = ShareKitDataFilltered[indexPath.row].name ?? ""
            SelectedUserImage = ShareKitDataFilltered[indexPath.row].photo ?? ""
            selectedConsumerId = ShareKitDataFilltered[indexPath.row].consumer_id ?? 0
        }else{
            SelectedUserName = dicData[indexPath.row].name ?? ""
            SelectedUserImage = dicData[indexPath.row].photo ?? ""
            selectedConsumerId = dicData[indexPath.row].consumer_id ?? 0
        }
        view.endEditing(true)
        UpdateShareData()
        ShareKitTableView.isHidden = true
    }
}

//MARK: - Hidde Keyboard extension
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
