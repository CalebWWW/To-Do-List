//
//  ChecklistTableViewCell.swift
//  to-do1
//
//  Created by Nathan Freeman on 3/27/24.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    @IBOutlet weak var todoTextLabel: UILabel!
    
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
