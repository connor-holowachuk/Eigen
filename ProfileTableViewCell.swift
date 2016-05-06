//
//  ProfileTableViewCell.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-30.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var ProfileImage: UIImageView!
    
    @IBOutlet var ProfileLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
