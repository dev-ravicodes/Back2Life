//
//  HomeTableViewCell.swift
//  Back2Life
//
//  Created by Bright on 19/07/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var radioButton: CheckBoxButton!
    @IBOutlet weak var checkBox: UIButton!
    
    
    var checkBoxClicked : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func checkBox(_ sender: Any) {
        
    }
    
    @IBAction func checkBoxButton(_ sender: UIButton) {
        //self.checkBoxClicked?()
//        if (checkBox.isSelected == true)
//            {
//            checkBox.setBackgroundImage(UIImage(named: "icons"), for: UIControl.State.normal)
//             checkBox.isSelected = false
//            }
//            else
//            {
//                checkBox.setBackgroundImage(UIImage(named: "iconSelected"), for: UIControl.State.normal)
//               checkBox.isSelected = true
//            }
    }
}
