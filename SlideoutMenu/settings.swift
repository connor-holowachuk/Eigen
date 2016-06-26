//
//  settings.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class settings : UIViewController {
    
    var segmentedControl = UISegmentedControl()
    var headerView = UIView()
    var headerLabel = UILabel()
    var slideMenuIcon = UIImageView()
    var slideMenuButton = UIButton()
    
    
    func segmentedControlAction(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentUser.preferedMapType = MKMapType.Standard
        case 1:
            currentUser.preferedMapType = MKMapType.Hybrid
        default:
            break
            
        }
        
    }


    override func viewDidLoad() {
        
        print("---- in settings view controller ----")
        
        
        if currentUser.preferedMapType == MKMapType.Standard {
            segmentedControl.setEnabled(true, forSegmentAtIndex: 0)
            segmentedControl.setEnabled(false, forSegmentAtIndex: 1)
        } else {
            segmentedControl.setEnabled(true, forSegmentAtIndex: 1)
            segmentedControl.setEnabled(false, forSegmentAtIndex: 0)
        }
        
        let segmentedControlWidth: CGFloat = 100.0
        self.segmentedControl.frame = CGRectMake(self.view.frame.width / 2.0 - segmentedControlWidth / 2.0, self.view.frame.height / 2.0 - 20, segmentedControlWidth, 40)
        self.segmentedControl.setTitle("Standard", forSegmentAtIndex: 0)
        self.segmentedControl.setTitle("Hybrid", forSegmentAtIndex: 1)
        self.view.addSubview(self.segmentedControl)
        
        
        self.headerView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height / 3.0)
        self.headerView.backgroundColor = UIColor.eigenBlueColor()
        self.view.addSubview(self.headerView)
        
        let iconSize: CGFloat = self.view.frame.height * 0.02954
        
        let headerTextHeight = self.view.frame.height * 0.057
        let headerLabelWidth: CGFloat = self.view.frame.width * 2.0 / 3
        let headerLabelExtraSpace: CGFloat = 3.0
        self.headerLabel.frame = CGRectMake((self.view.frame.width / 2.0) - (headerLabelWidth / 2.0), self.view.frame.height * 0.061 - headerLabelExtraSpace, headerLabelWidth, headerTextHeight + 2.0 * headerLabelExtraSpace)
        self.headerLabel.text = "settings"
        self.headerLabel.textAlignment = NSTextAlignment.Center
        self.headerLabel.textColor = UIColor.whiteColor()
        self.headerLabel.font = UIFont(name: "AvenirNext-Regular", size: headerTextHeight)
        self.view.addSubview(headerLabel)
        
        let slideMenuIconY = self.headerLabel.frame.origin.y + self.headerLabel.frame.size.height / 2.0 - iconSize / 2.0
        self.slideMenuIcon.frame = CGRectMake(self.view.frame.width * 0.055556, slideMenuIconY, iconSize, iconSize)
        self.slideMenuIcon.image = UIImage(named: "slide_menu_icon")
        self.view.addSubview(slideMenuIcon)
        
        let sMBES: CGFloat = 10.0
        self.slideMenuButton.frame = CGRectMake(self.slideMenuIcon.frame.origin.x - sMBES, self.slideMenuIcon.frame.origin.y - sMBES, self.slideMenuIcon.frame.width + (2 * sMBES), self.slideMenuIcon.frame.height + (2 * sMBES))
        self.slideMenuButton.titleLabel?.text = ""
        self.slideMenuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(slideMenuButton)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //color of status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }

}