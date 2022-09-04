//
//  Notification_TVC.swift
//  Back2Life
//
//  Created by Mohini's Mac on 07/10/21.
//

import UIKit
import Kingfisher

class Notification_TVC: UITableViewCell {
    
    @IBOutlet weak var lbl_Result: UILabel!
    
    //@IBOutlet weak var lbl_TestName: UILabel!
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetData(data: NotificationData) {
        lbl_Name.text = data.name
        lbl_Description.text = data.notification_text
        //lbl_TestName.text = data.test_data?.Name ?? ""
        let tetxt = "Dein Test Ergebnis Liegt vor und Kann abgeruten werden!"
        lbl_Result.isHidden = true
        if data.notification_text == "report has been submitted" {
            lbl_Description.text = tetxt
            lbl_Result.isHidden = false
        }
        
        
        DispatchQueue.main.async {
            self.img_User.kf.setImage(with: URL(string: data.photo ?? ""))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
