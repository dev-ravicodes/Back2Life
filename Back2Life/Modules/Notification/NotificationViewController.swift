//
//  NotificationViewController.swift
//  Back2Life
//
//  Created by Bright on 24/05/21.
//

import UIKit

class NotificationViewController: MainBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_Notification: UILabel!
    var router : HTTPRequest<AuthenticationEndPoint>?
    var arrData = [NotificationData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // addImageNav()
        tableView.rowHeight = 165
        router = HTTPRequest<AuthenticationEndPoint>()
        GetNotification()
    }
    
    func GetNotification() {
        self.showActivity()
        router?.request(.getNotification, type: NotificationModel.self, completion: { [self] (response) in
            self.hideActivity()
            print(response)
            switch response{
            case .success(let resp):
                print(resp)
                self.arrData = resp.data ?? [NotificationData]()
                if self.arrData.count > 0 {
                    self.tableView.reloadData()
                    self.lbl_Notification.isHidden = true
                }
                else {
                    self.tableView.isHidden = true
                    self.lbl_Notification.isHidden = false
                }
                
                self.tableView.reloadData()
                //self.showMessage(resp.message ?? "")
                break
            case .failure(let err):
                self.showMessage(err.localizedDescription)
                
                break
            }
        })
    }
    
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Notification_TVC.identifier, for: indexPath) as? Notification_TVC else {
            fatalError()
        }
    
        cell.SetData(data: arrData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrData[indexPath.row].notification_text == "report has been submitted" {
            let order_id = arrData[indexPath.row].order_id ?? 0
            let report_id = arrData[indexPath.row].report_id ?? 0
            print(order_id)
            print(report_id)
            orderId = order_id
            reportId = report_id
            navigate(.postivereport(orderId: orderId ?? 0, reportId: reportId ?? 0))
        }
    }
}

