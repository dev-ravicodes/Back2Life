//
//  ShareKitTableViewCell.swift
//  Back2Life
//
//  Created by Mohini's Mac on 09/02/22.
//

import UIKit

class ShareKitTableViewCell: UITableViewCell {

    @IBOutlet var UserImage: UIImageView!
    @IBOutlet var UserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
