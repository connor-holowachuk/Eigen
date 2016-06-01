//
//  ViewController.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-28.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var varView = Int()
    
    
    override func viewDidLoad() {
        
        print("---- opening view controller loaded ----")
        
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

