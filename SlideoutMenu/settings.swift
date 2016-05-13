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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
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
        
        /*
        if currentUser.preferedMapType == MKMapType.Standard {
            segmentedControl.setEnabled(true, forSegmentAtIndex: 0)
            segmentedControl.setEnabled(false, forSegmentAtIndex: 1)
        } else {
            segmentedControl.setEnabled(true, forSegmentAtIndex: 1)
            segmentedControl.setEnabled(false, forSegmentAtIndex: 0)
        }
        */
        segmentedControl.setTitle("Standard", forSegmentAtIndex: 0)
        segmentedControl.setTitle("Hybrid", forSegmentAtIndex: 1)

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
}