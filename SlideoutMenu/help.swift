//
//  help.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation

class help : UIViewController {
    
    var headerImage = UIImageView()
    var headerLabel = UIImageView()
    var slideMenuIcon = UIImageView()
    
    override func viewDidLoad() {
        
        print("---- in help view controller ----")
        
        self.headerImage.frame = CGRectMake(0, 0, self.view.frame.width, self.view.bounds.height / 3.0 + (self.view.bounds.height * 0.02273863068))
        self.headerImage.image = UIImage(named: "white_header_background_with_shade")
        self.view.addSubview(headerImage)
        
        let headerLabelWidth: CGFloat = self.view.frame.width / 3.3334
        let headerLabelHeight: CGFloat = headerLabelWidth * 100.0 / 205.0
        self.headerLabel.frame = CGRectMake((self.view.frame.width / 2.0) - (headerLabelWidth / 2.0), self.view.frame.height / 12.0 - 10, headerLabelWidth, headerLabelHeight)
        self.headerLabel.image = UIImage(named: "help_title_header")
        self.view.addSubview(headerLabel)
        
        let iconSize: CGFloat = self.view.frame.height * 0.02464467766
        
        let slideMenuIconY = self.headerLabel.frame.origin.y + self.headerLabel.frame.size.height / 2.0 - iconSize / 2.0 - 5
        self.slideMenuIcon.frame = CGRectMake(self.view.frame.width * 0.055556, slideMenuIconY, iconSize, iconSize)
        self.slideMenuIcon.image = UIImage(named: "slide_menu_icon")
        self.view.addSubview(slideMenuIcon)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
}