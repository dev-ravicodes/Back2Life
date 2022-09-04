//
//  userListTableViewCell.swift
//  Back2Life
//
//  Created by Mohini's Mac on 07/12/21.
//

import UIKit

class userListTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var uploadIdBtn: UIButton!
    @IBOutlet weak var uploadIdImage: UIImageView!
    @IBOutlet weak var uploadKitBtn: UIButton!
    @IBOutlet weak var uploadKitImage: UIImageView!
    @IBOutlet weak var dropDownBtn: UIButton!
   // @IBOutlet weak var orderId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
