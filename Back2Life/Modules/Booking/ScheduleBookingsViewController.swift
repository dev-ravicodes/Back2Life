//
//  ScheduleBookingsViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 14/05/21.
//

import UIKit
import SnapKit
import Designable

var backScreen : String?

class ScheduleBookingsViewController: MainBaseViewController {
    
    // MARK: - Outlets
    var router : HTTPRequest<AuthenticationEndPoint>?
    var arrScheduleBooking = [ScheduleBookingData]()
    var arrOrderListing = [OrderListingData]()
    @IBOutlet weak var lbl_NoData: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_NewBooking: DesignableButton!
    
    // MARK: - Properties
    
    lazy private var backgroundView: DesignableView = {
        var view: DesignableView = DesignableView()
        view.backgroundColor = AppColor.primaryBackgroundColor
        return view
    }()
    
    enum BookingType {
        case schedule
        case past
    }
    
    var bookingType: BookingType = .schedule
    var isBooking = true
    var timer: Timer?
 //   let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)

    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = HTTPRequest<AuthenticationEndPoint>()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(for: BookingsTableViewCell.self,
                           withIdentifier: BookingsTableViewCell.identifier)
        tableView.register(for: OrderTableViewCell.self,
                           withIdentifier: OrderTableViewCell.identifier)
        tableView.contentInset.top = 50
        tableView.contentInset.bottom = 20
        tableView.layoutIfNeeded()
        if backScreen == "MEINE BUCHUNG"{
           timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
                       self?.GetScheduleBookig()
                   })
        }

        //        switch bookingType {
        //        case .past:
        //            navigationItem.title = "Letzte Buchungen"
        //        case .schedule:
        //            navigationItem.title = "Buchungsübersicht"
        //        }
        
        view.insertSubview(backgroundView, belowSubview: tableView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.top).offset(80)
        }
        backgroundView.roundedCorners(corners: [.leftTop, .rightTop], with: 20)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isBooking {
            GetScheduleBookig()
            btn_NewBooking.isHidden = false
        }
        else {
            GetOrderListing()
            btn_NewBooking.isHidden = true
            }
    }
    
    func GetScheduleBookig() {
      //  self.showActivity()
        router?.request(.getScheduleBooking, type: SchedulBookingModel.self, completion: { [self] (response) in
          //  self.hideActivity()
            print(response)
            switch response{
            case .success(let resp):
                print(resp)
                self.arrScheduleBooking = resp.data ?? [ScheduleBookingData]()
                self.lbl_NoData.isHidden = false
                self.tableView.isHidden = true
                if self.arrScheduleBooking.count > 0 {
                    self.lbl_NoData.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
                
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                
                break
            }
        })
    }
    
    func GetOrderListing() {
        self.showActivity()
        router?.request(.orderListing, type: OrderListingModel.self, completion: { [self] (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let resp):
                print(resp)
                self.arrOrderListing = resp.data ?? [OrderListingData]()
                self.lbl_NoData.isHidden = false
                self.tableView.isHidden = true
                if self.arrOrderListing.count > 0 {
                    self.lbl_NoData.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                
                break
            }
        })
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    // MARK: - IBOutlets
    @IBAction func btn_New(_ sender: UIButton) {
        self.navigate(.booking([:], false))
    }
    
    // MARK: - Additional Helpers
}
// MARK: - UITableViewDelegate

extension ScheduleBookingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigate(.profile)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleBookingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isBooking {
            return arrScheduleBooking.count
        }
        return arrOrderListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        if isBooking {
            guard let bookingCell = tableView.dequeueReusableCell(withIdentifier: BookingsTableViewCell.identifier, for: indexPath) as? BookingsTableViewCell else {
                fatalError()
            }
            print(arrScheduleBooking[indexPath.row])
            bookingCell.SetData(data: arrScheduleBooking[indexPath.row])
            var testerNumber = arrScheduleBooking[indexPath.row].tester?.number
            let status = arrScheduleBooking[indexPath.row].status
            bookingCell.btn_VideoConnect.tag = indexPath.row
            if status == "completed" {
                
                bookingCell.btn_VideoConnect.setTitle("Abgeschlossen", for: .normal)
                bookingCell.btn_VideoConnect.backgroundColor = UIColor(red: 236, green: 81, blue: 118)
                bookingCell.btn_VideoConnect.removeTarget(nil, action: nil, for: .allEvents)
                
            }
            else if status == "created" {
                
                bookingCell.btn_VideoConnect.setTitle("NEU", for: .normal)
                bookingCell.btn_VideoConnect.backgroundColor = UIColor(red: 236, green: 81, blue: 118)
                bookingCell.btn_VideoConnect.removeTarget(nil, action: nil, for: .allEvents)
            }
            else {
                bookingCell.img_Tester.isHidden = false
                bookingCell.btn_VideoConnect.setTitle("Video Meeting", for: .normal)
                bookingCell.btn_VideoConnect.backgroundColor = .systemPurple
                bookingCell.btn_VideoConnect.tag = indexPath.row
                bookingCell.btn_VideoConnect.addTarget(self, action: #selector(vedioCall), for: .touchUpInside)
            }
            
            if arrScheduleBooking[indexPath.row].booking_info!.indices.contains(0) {
                bookingCell.FirstUserImage.isHidden = false
                bookingCell.FirstUserImage.kf.setImage(with: URL(string: arrScheduleBooking[indexPath.row].booking_info?[0].user_id_card ?? ""))
                bookingCell.FirstUserName.text = arrScheduleBooking[indexPath.row].booking_info?[0].user_name ?? ""
            }
            if arrScheduleBooking[indexPath.row].booking_info!.indices.contains(1) {
                bookingCell.SecondUserImage.isHidden = false
                bookingCell.SecondUserImage.kf.setImage(with: URL(string: arrScheduleBooking[indexPath.row].booking_info?[1].user_id_card ?? ""))
                bookingCell.SecondUserName.text = arrScheduleBooking[indexPath.row].booking_info?[1].user_name ?? ""
            }
            if arrScheduleBooking[indexPath.row].booking_info!.indices.contains(2) {
                bookingCell.ThirdUserImage.isHidden = false
                bookingCell.ThirdUserImage.kf.setImage(with: URL(string: arrScheduleBooking[indexPath.row].booking_info?[2].user_id_card ?? ""))
                bookingCell.ThirdUserName.text = arrScheduleBooking[indexPath.row].booking_info?[2].user_name ?? ""
            }
            if arrScheduleBooking[indexPath.row].booking_info!.indices.contains(3) {
                bookingCell.FourthUserImage.isHidden = false
                bookingCell.SecondUserImage.kf.setImage(with: URL(string: arrScheduleBooking[indexPath.row].booking_info?[3].user_id_card ?? ""))
                bookingCell.FourthUserName.text = arrScheduleBooking[indexPath.row].booking_info?[3].user_name ?? ""
            }
            if arrScheduleBooking[indexPath.row].booking_info!.indices.contains(4) {
                bookingCell.FifthUserImage.isHidden = false
                bookingCell.FifthUserImage.kf.setImage(with: URL(string: arrScheduleBooking[indexPath.row].booking_info?[4].user_id_card ?? ""))
                bookingCell.FifthUserName.text = arrScheduleBooking[indexPath.row].booking_info?[4].user_name ?? ""
            }
            return bookingCell
        }
        else {
            guard let orderCell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as? OrderTableViewCell else {
                fatalError()
            }
            orderCell.SetData(data: arrOrderListing[indexPath.row])
            return orderCell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func vedioCall(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        let cell = self.tableView.cellForRow(at: indexPath!) as! BookingsTableViewCell
        cell.lbl_TestePhoneNumber.text = arrScheduleBooking[indexPath!.row].tester?.number
       // cell.report = dataList[indexPath!.row].report ?? [Report]()
       //  print(cell.userNameLabel.text)//print or get item
        if #available(iOS 10.0, *) {
            
            if UIApplication.shared.canOpenURL(NSURL(string: "whatsapp://send?phone=\(cell.lbl_TestePhoneNumber.text ?? "")")! as URL) {
                UIApplication.shared.open(NSURL(string: "whatsapp://send?phone=\(cell.lbl_TestePhoneNumber.text ?? "")")! as URL)
            }
            else {
                showMessage("Please install whatsapp to make call")
            }
             
          } else {
            if UIApplication.shared.canOpenURL(NSURL(string: "whatsapp://send?phone=\(cell.lbl_TestePhoneNumber.text ?? "")")! as URL) {
                UIApplication.shared.openURL(NSURL(string: "whatsapp://send?phone=\(cell.lbl_TestePhoneNumber.text ?? "")")! as URL)
            }
            else {
                showMessage("Please install whatsapp to make call")
            }
             
          }
    }
}

