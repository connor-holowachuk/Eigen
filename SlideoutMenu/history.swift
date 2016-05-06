//
//  history.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class history : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        
        print(currentViewController)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.tripLog.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndex = (currentUser.tripLog.count - 1) - indexPath.row
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoryCell
        cell.HeadingLabel.text = timeStampToString(currentUser.tripLog[cellIndex].startTimeStamp)
        var totalPayment : Double = 0
        
        for index in 0...(currentUser.tripLog[cellIndex].paymentFromAdvertisers.count - 1) {
            totalPayment += currentUser.tripLog[cellIndex].paymentFromAdvertisers[index]
        }
        cell.SubheadingLabel.text = "$\(roundDouble(totalPayment, decimalPlaces: 2)) CAD"
        
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