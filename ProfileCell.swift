//
//  ProfileCell.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-30.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var ProfileLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
