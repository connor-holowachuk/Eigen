//
//  Hello.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-28.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation

class Hello : UIViewController {
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        currentViewController = 0
    }
    
}