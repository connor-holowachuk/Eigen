//
//  ViewController.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-28.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

var currentViewController: Int!


class ViewController: UIViewController {

    @IBOutlet var open: UIBarButtonItem!
    @IBOutlet var Label: UILabel!
    
    var varView = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

