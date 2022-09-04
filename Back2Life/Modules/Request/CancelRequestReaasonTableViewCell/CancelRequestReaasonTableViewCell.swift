//
//  CancelRequestReaasonTableViewCell.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

class CancelRequestReaasonTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Addiotional Helper Functions
    
    func configure(with reason: String) {
        titleLabel.text = reason
    }
}
