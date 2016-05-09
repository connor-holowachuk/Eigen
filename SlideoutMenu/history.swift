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

class history : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataToPassDelegate: PassDataDelegate? = nil
    var indexToPass: Int = 0
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.tripLog.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndex = (currentUser.tripLog.count - 1) - indexPath.row
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoryCell
        cell.HeadingLabel.text = timeStampToString(currentUser.tripLog[cellIndex].startTimeStamp)
        
        cell.mapView.delegate = cell
        
        var totalPayment : Double = 0
        for index in 0...(currentUser.tripLog[cellIndex].paymentFromAdvertisers.count - 1) {
            totalPayment += currentUser.tripLog[cellIndex].paymentFromAdvertisers[index]
        }
        cell.SubheadingLabel.text = "$\(roundDouble(totalPayment, decimalPlaces: 2)) CAD"
        let maxIndex = currentUser.tripLog[cellIndex].tripPath.count
        //let halfIndex = Int(currentUser.tripLog[cellIndex].tripPath.count / 2)
        //let center = currentUser.tripLog[cellIndex].tripPath[halfIndex]
        
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
        
        
        let polyLineMaxIndex = currentUser.tripLog[cellIndex].tripPath.count - 2
        for index in 0...polyLineMaxIndex {
            let sourceIndex = index
            let newIndex = index + 1
            
            let sourceCoordinate = currentUser.tripLog[cellIndex].tripPath[sourceIndex]
            let newCoordinate = currentUser.tripLog[cellIndex].tripPath[newIndex]
            
            var a = [sourceCoordinate, newCoordinate]
            //print("a:\(a)")
            
            let polyLine = MKPolyline(coordinates: &a, count: a.count)
            
            cell.mapView.addOverlay(polyLine)
            cell.mapView.rendererForOverlay(polyLine)
            print(cell.mapView.rendererForOverlay(polyLine))
        }
        
        //let polyLine = MKPolyline(coordinates: &(currentUser.tripLog[cellIndex].tripPath), count: (currentUser.tripLog[cellIndex].tripPath).count)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexToPass = indexPath.row
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
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    */
    
    
    
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