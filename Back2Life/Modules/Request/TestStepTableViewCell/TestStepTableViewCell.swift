//
//  TestStepTableViewCell.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

class TestStepTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Addiotional Helper Functions
    
    func configure(with step: String) {
        titleLabel.text = step
    }
}
