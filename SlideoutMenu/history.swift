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


protocol PassDataDelegate {
    func userToPassData(passingIndex: Int)
}


class history : UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    var tableView = UITableView()
    var headerImage = UIImageView()
    
    var headerLabel = UIImageView()
    var slideMenuIcon = UIImageView()
    var slideMenuButton = UIButton()
    
    var noDataToDisplayLabel = UILabel()
    
    var dataToPassDelegate: PassDataDelegate? = nil
    var indexToPass: Int = 0
    
    
    override func viewDidLoad() {
        
        
        print("---- in history view controller ----")
        super.viewDidLoad()
        
        let tableViewRect = CGRectMake(0, self.view.frame.height / 3.0, self.view.frame.width, self.view.frame.height * 2.0 / 3.0)
        self.tableView.frame = tableViewRect
        //self.tableView.separatorColor = UIColor.lightGrayColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(HistoryCell.self, forCellReuseIdentifier: "cell")
        
        self.noDataToDisplayLabel.text = "no data to display"
        self.noDataToDisplayLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        self.noDataToDisplayLabel.textColor = UIColor.darkTextColor()
        self.noDataToDisplayLabel.textAlignment = NSTextAlignment.Center
        self.noDataToDisplayLabel.frame = CGRectMake(0, self.view.frame.height * 2.0 / 3.0 - 10, self.view.frame.width, 50)
        
        print(currentUser.tripLog.isEmpty)
        
        if currentUser.tripLog.isEmpty == false {
            self.view.addSubview(self.tableView)
        } else {
            self.view.addSubview(self.noDataToDisplayLabel)
        }
        self.headerImage.frame = CGRectMake(0, 0, self.view.frame.width, self.view.bounds.height / 3.0 + (self.view.bounds.height * 0.02273863068))
        self.headerImage.image = UIImage(named: "white_header_background_with_shade")
        self.view.addSubview(headerImage)
        
        let headerLabelWidth: CGFloat = self.view.frame.width / 3.3334
        let headerLabelHeight: CGFloat = headerLabelWidth * 100.0 / 205.0
        self.headerLabel.frame = CGRectMake((self.view.frame.width / 2.0) - (headerLabelWidth / 2.0), self.view.frame.height / 12.0 - 15, headerLabelWidth, headerLabelHeight)
        self.headerLabel.image = UIImage(named: "history_title_header")
        self.view.addSubview(headerLabel)
        
        let iconSize: CGFloat = self.view.frame.height * 0.02464467766
        
        let slideMenuIconY = self.headerLabel.frame.origin.y + self.headerLabel.frame.size.height / 2.0 - iconSize / 2.0 - 5
        self.slideMenuIcon.frame = CGRectMake(self.view.frame.width * 0.055556, slideMenuIconY, iconSize, iconSize)
        self.slideMenuIcon.image = UIImage(named: "slide_menu_icon")
        self.view.addSubview(slideMenuIcon)
        
        let sMBES: CGFloat = 10.0
        self.slideMenuButton.frame = CGRectMake(self.slideMenuIcon.frame.origin.x - sMBES, self.slideMenuIcon.frame.origin.y - sMBES, self.slideMenuIcon.frame.width + (2 * sMBES), self.slideMenuIcon.frame.height + (2 * sMBES))
        self.slideMenuButton.titleLabel?.text = ""
        self.slideMenuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(slideMenuButton)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.tripLog.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 6.0
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndex = (currentUser.tripLog.count - 1) - indexPath.row
        
        let cell: HistoryCell = tableView.dequeueReusableCellWithIdentifier("cell") as! HistoryCell
        cell.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height / 6.0)
        
        let dayOfTrip: String = currentUser.tripLog[cellIndex].stopTimeStamp.calculateDate()
        cell.HeadingLabel.text = dayOfTrip
        cell.HeadingLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        cell.HeadingLabel.textColor = UIColor(hex: 0x515151)
        cell.HeadingLabel.textAlignment = NSTextAlignment.Center
        cell.HeadingLabel.frame = CGRectMake(cell.bounds.width / 3.0, cell.bounds.height / 6.0, cell.bounds.width * 2.0 / 3.0, 20)
        cell.addSubview(cell.HeadingLabel)
        
        cell.mapView.delegate = cell
        cell.mapView.frame = CGRectMake(cell.bounds.width / 12.0, cell.bounds.height / 6.0, cell.bounds.width / 3.0, cell.bounds.height * 2.0 / 3.0)
        
        var totalPayment : Double = 0
        for index in 0...(currentUser.tripLog[cellIndex].paymentFromAdvertisers.count - 1) {
            totalPayment += currentUser.tripLog[cellIndex].paymentFromAdvertisers[index]
        }
        
        cell.SubheadingLabel.text = "\(currentUser.tripLog[cellIndex].startTimeStamp.calculateTime())-\(currentUser.tripLog[cellIndex].stopTimeStamp.calculateTime())"
        cell.SubheadingLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        cell.SubheadingLabel.textColor = UIColor(hex: 0x515151)
        cell.SubheadingLabel.textAlignment = NSTextAlignment.Center
        cell.SubheadingLabel.frame = CGRectMake(cell.frame.width / 3.0, cell.frame.height / 3.0 + 10, cell.frame.width * 2.0 / 3.0, 20)
        cell.addSubview(cell.SubheadingLabel)
        
        cell.PaymentLabel.text = "$\(roundDouble(totalPayment, decimalPlaces: 2))"
        cell.PaymentLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        cell.PaymentLabel.textColor = UIColor(hex: 0x515151)
        cell.PaymentLabel.textAlignment = NSTextAlignment.Center
        cell.PaymentLabel.frame = CGRectMake(cell.frame.width / 3.0, cell.frame.height / 2.0 + 20, cell.frame.width * 2.0 / 3.0, 20)
        cell.addSubview(cell.PaymentLabel)
        
        
        let maxIndex = currentUser.tripLog[cellIndex].tripPath.count
        
        var latitudeArray: [Double] = []
        var longitudeArray: [Double] = []
        
        for index in 0...(maxIndex - 1) {
            latitudeArray.append(currentUser.tripLog[cellIndex].tripPath[index].latitude)
            longitudeArray.append(currentUser.tripLog[cellIndex].tripPath[index].longitude)
        }
        
        let maxLat = latitudeArray.maxElement()
        let minLat = latitudeArray.minElement()
        let deltaLat = abs(maxLat! - minLat!)
        
        let maxLon = longitudeArray.maxElement()
        let minLon = longitudeArray.minElement()
        let deltaLon = abs(maxLon! - minLon!)
        
        var deltaCoord: Double = 0.0
        
        if deltaLat > deltaLon {
            deltaCoord = deltaLat * 1.618033
        } else {
            deltaCoord = deltaLon * 1.618033
        }

        let displayCenter = CLLocationCoordinate2D(latitude: (maxLat! + minLat!) / 2.0, longitude: (maxLon! + minLon!) / 2)
        let region = MKCoordinateRegion(center: displayCenter, span: MKCoordinateSpan(latitudeDelta: deltaCoord, longitudeDelta: deltaCoord))
        cell.mapView.setRegion(region, animated: false)
        cell.mapView.rotateEnabled = false
        cell.mapView.scrollEnabled = false
        cell.mapView.zoomEnabled = false
        cell.mapView.pitchEnabled = false
        
        let polyLineMaxIndex = currentUser.tripLog[cellIndex].tripPath.count - 2
        for index in 0...polyLineMaxIndex {
            let sourceIndex = index
            let newIndex = index + 1
            
            let sourceCoordinate = currentUser.tripLog[cellIndex].tripPath[sourceIndex]
            let newCoordinate = currentUser.tripLog[cellIndex].tripPath[newIndex]
            
            var a = [sourceCoordinate, newCoordinate]
            
            let polyLine = MKPolyline(coordinates: &a, count: a.count)
            
            cell.mapView.addOverlay(polyLine)
            cell.mapView.rendererForOverlay(polyLine)
        }
        
        cell.mapViewBackShade.frame = CGRectMake(cell.mapView.frame.origin.x - 2, cell.mapView.frame.origin.y - 2, cell.mapView.frame.width + 4, cell.mapView.frame.height + 12)
        cell.mapViewBackShade.image = UIImage(named: "shadded_background")
        cell.mapViewBackShade.alpha = 0.8
        cell.addSubview(cell.mapViewBackShade)
        
        cell.addSubview(cell.mapView)
        
        let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.width))
        selectedView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexToPass = indexPath.row
        
        let infoVC = storyboard!.instantiateViewControllerWithIdentifier("HistoryViewControllerForPages") as! HistoryViewControllerForPages
        infoVC.transitioningDelegate = self
        presentViewController(infoVC, animated: true, completion: nil)
    }
    
    
    func timeStampToString(timeStamp: TimeStamp) -> String {
        var hour: Int = timeStamp.hour
        var timeSign: String = "AM"
        
        if timeStamp.hour > 12 {
            hour -= 12
            timeSign = "PM"
        }
        
        var timeStampString: String = ""
        
        if timeStamp.minute >= 10 {
            timeStampString = "\(timeStamp.month)/\(timeStamp.day)/\(timeStamp.year) \(hour):\(timeStamp.minute)\(timeSign)"
        } else {
            timeStampString = "\(timeStamp.month)/\(timeStamp.day)/\(timeStamp.year) \(hour):0\(timeStamp.minute)\(timeSign)"
        }
        return timeStampString
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (dataToPassDelegate != nil) {
            dataToPassDelegate!.userToPassData(indexToPass)
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
}
