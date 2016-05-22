//
//  HistoryViewController.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-13.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UIPageViewControllerDataSource {

    var pageVieeController: UIPageViewController!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        
    }
    
    @IBOutlet weak var colouredBackdropImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageVieeController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryPageViewController") as! UIPageViewController
        self.colouredBackdropImage.frame = CGRect(x: <#T##CGFloat#>, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 3.0)
        self.colouredBackdropImage.image = UIImage(named: "colouredBackground")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        var vc: 
    }
    
    

}
