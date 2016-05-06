//
//  history.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation

class history : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        currentViewController = 2
        print(currentViewController)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.tripLog.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoryCell
        cell.HeadingLabel.text = timeStampToString(currentUser.tripLog[indexPath.row].startTimeStamp)
        cell.SubheadingLabel.text = "Subheading"
        
        return cell
    }
    
    func timeStampToString(timeStamp: TimeStamp) -> String {
        var hour: Int = timeStamp.hour
        var timeSign: String = "AM"
        
        if timeStamp.hour > 12 {
            hour -= 12
            timeSign = "PM"
        }
        
        let timeStampString = "\(timeStamp.month)/\(timeStamp.day)/\(timeStamp.year) \(hour):\(timeStamp.minute)\(timeSign)"
        return timeStampString
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        <#code#>
    }
    */
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
}