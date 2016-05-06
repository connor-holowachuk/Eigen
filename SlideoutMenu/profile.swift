//
//  profile.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation

class profile : UIViewController {
    @IBOutlet var profilePicImageView: UIImageView!
    override func viewDidLoad() {
        
        currentViewController = 1
        print(currentViewController)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
}