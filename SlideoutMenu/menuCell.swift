//
//  MenuCell.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-30.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet var MenuImage: UIImageView!
    @IBOutlet var MenuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
