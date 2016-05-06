//
//  HistoryCell.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-06.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var HeadingLabel: UILabel!
    @IBOutlet weak var SubheadingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
