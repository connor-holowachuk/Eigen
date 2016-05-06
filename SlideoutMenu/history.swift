//
//  history.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation

class history : UIViewController {
    override func viewDidLoad() {
        
        currentViewController = 2
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