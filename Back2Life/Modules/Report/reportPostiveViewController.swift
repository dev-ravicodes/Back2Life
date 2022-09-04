//
//  reportPostiveViewController.swift
//  Back2Life
//
//  Created by Bright on 24/05/21.
//

import UIKit
import Designable
import IQKeyboardManagerSwift


var orderId: Int?
var reportId: Int?

class reportPostiveViewController: MainBaseViewController {
    
    @IBOutlet weak var view_GiveRating: FloatRatingView!
    
    @IBOutlet weak var txtView_Rating: IQTextView!
    
    @IBOutlet weak var btn_Close: UIButton!
    @IBOutlet weak var view_Rating: UIView!
    @IBOutlet weak var btn_RateNow: DesignableButton!
    @IBOutlet weak var view_Detail: DesignableView!
    @IBOutlet weak var lbl_ReportStatus: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var licenceView: UIView!
    @IBOutlet weak var img_ReportIcon: UIImageView!
    @IBOutlet weak var img_Report: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_ReportDateTime: UILabel!
    @IBOutlet weak var lbl_AddressTest: UILabel!
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var img_TesterDocument: UIImageView!
    @IBOutlet weak var lbl_ReportCreate: UILabel!
    @IBOutlet weak var lbl_IdDate: UILabel!
    @IBOutlet weak var lbl_RedColorDateTime: UIButton!
    
    var router : HTTPRequest<AuthenticationEndPoint>?
    var dicData:ReportStatusData?
 
    var report: Int?
    var ComeFrom: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtView_Rating.layer.borderColor = AppColor.primaryThemeColor.cgColor
        router = HTTPRequest<AuthenticationEndPoint>()
        addImageNav()
        //licenceView.isHidden = true
        //ratingView.isHidden = true
        print(orderId ?? 0)
        print(reportId ?? 0)
        GetReportDetail(id:orderId ?? 0, id2: reportId ?? 0)

    }
    @IBAction func hide(_ sender: Any) {
        licenceView.isHidden = true
    }
    
    @IBAction func licenceButtonAction(_ sender: Any) {
        licenceView.isHidden = false
    }
    
    @IBAction func starButton(_ sender: Any) {
        ratingView.isHidden = false
    }
    
    @IBAction func btn_RateNow(_ sender: UIButton) {
        view_Rating.isHidden = false
    }
    
    @IBAction func btn_GiveRating(_ sender: UIButton) {
        if txtView_Rating.text == "" {
            showMessage("Please enter comment")
            return
        }
        if view_GiveRating.rating == 0 {
            showMessage("Please give star")
            return
        }
        GiveRating()
    }
    
    @IBAction func btn_CloseRating(_ sender: UIButton) {
        view_Rating.isHidden = true
    }
    
    @IBAction func submitAction(_ sender: Any) {
        ratingView.isHidden = true
        licenceView.isHidden = true
        navigate(.home)
    }
    
    func GiveRating() {
        self.showActivity()
        if let testerId = self.dicData?.booking_data?[0].tester_id {
            let params = [
                "tester_id": testerId,
                "rate": view_GiveRating.rating,
                "comment": txtView_Rating.text!,
                "order_id": dicData?.report_Data?[0].order_id!,
            ] as [String : Any]
            router?.request(.giveRating(params), type: CustomerProfilePost.self, completion: { [self] (response) in
                self.hideActivity()
                print(response)
                switch response{
                case .success(let resp):
                    print(resp)
                    self.showMessage(resp.message ?? "")
                    self.view_Rating.isHidden = true
                   // navigate(.home)
                    break
                case .failure(let err):
                    self.showMessage(err.localizedDescription)
                    
                    break
                }
            })
        }
        
    }
    
    func GetReportDetail(id:Int,id2:Int) {
        self.showActivity()
        router?.request(.getReportStatus(_id: orderId ?? 0, id2: reportId ?? 0), type: ReportStatusModel.self, completion: { [self] (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let resp):
                print(resp)
                print(resp.data)
                self.dicData = resp.data as ReportStatusData?
                self.showMessage(resp.message ?? "")
                self.ConfigureUI()
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                break
            }
        })
    }
    
    func ConfigureUI() {
        view_Detail.isHidden = false
        let result = dicData?.report_info?.result ?? "No Result found"
        lbl_ReportStatus.text = "Covid - 19 \(result)"
        //ratingView
        //licenceView
        
        lbl_Name.text = dicData?.report_info?.user_name
        let dateTime = MonthNameDateYear(date: dicData?.report_info?.report_date ?? "")
        lbl_ReportDateTime.text = dateTime
      //  print(dicData?.booking_data?[0].test_data?.name)
        let testData = dicData?.booking_data?[0].test_data?.name
        let subString = testData?.dropFirst(3)
//        lbl_AddressTest.text = String(subString)
        img_User.image = UIImage.init(named: "")
        if result == "positive" {
            img_ReportIcon.image = UIImage.init(named: "positive")
            lbl_ReportCreate.text = "Dein Testergebnis ist \(result). Bitte vereinbare einen Termin für den PoC Antigen 2cm Nasentest"
            //\(dicData?.booking_data?[0].test_data?.name ?? "")"
        }
        else if result == "negative" {
            img_ReportIcon.image = UIImage.init(named: "negative")
            
            lbl_ReportCreate.text = "Dein Testergebnis ist Negativ."
        }

        let text = "Gültig ab \(dateTime ?? "")"
        lbl_RedColorDateTime.setTitle(text, for: .normal)
        DispatchQueue.main.async {
            //self.img_TesterDocument.kf.setImage(with: URL(string: self.dicData?.booking_data?[0].id_card ?? ""))
            self.img_User.kf.setImage(with: URL(string: self.dicData?.report_info?.user_id_card ?? ""))
        }
    }
    
    
    func MonthNameDateYear(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let dateValue = dateFormatter.date(from: date) else { return nil }
        dateFormatter.dateFormat = "d-MM-yyyy / HH:mm"
        return dateFormatter.string(from: dateValue)
    }
}
