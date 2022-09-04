//
//  OrderTableViewCell.swift
//  Back2Life
//
//  Created by Mohini's Mac on 22/11/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_TestKitName: UILabel!
    @IBOutlet weak var lbl_Quatity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func SetData(data: OrderListingData) {
        selectionStyle = .none
        lbl_Name.text = data.name
        lbl_Quatity.text = "\(String(describing: data.number_of_kits ?? 0))"
        let str = data.test_data_info?.Name
        let result3 = String(str!.dropFirst(3))
        lbl_TestKitName.text = result3
        
    }
    
}


