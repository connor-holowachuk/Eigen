//
//  RideInfo.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-05-03.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import MapKit

extension NSDate
{
    func year() -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Year, fromDate: self)
        let year = components.year
        
        return year
    }
    
    func month() -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Month, fromDate: self)
        let month = components.month
        
        return month
    }
    
    func day() -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Day, fromDate: self)
        let day = components.day
        
        return day
    }
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func second() -> Int
    {
        //Get Second
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Second, fromDate: self)
        let second = components.second
        
        //Return Second
        return second
    }
    
    func timeInSeconds() -> Int
    {
        let hoursInSeconds = hour() * 3_600
        let minutesInSeconds = minute() * 60
        let seconds = second()
        let timeInSec = hoursInSeconds + minutesInSeconds + seconds
        
        return timeInSec
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
}

struct TimeStamp {
    var year: Int
    var month: Int
    var day: Int
    
    var hour: Int
    var minute: Int
}

struct TripInfoForMem {
    var startTimeStamp: TimeStamp
    var stopTimeStamp: TimeStamp
    
    var paymentFromAdvertisers: [Double]
    
    var tripPath: [CLLocationCoordinate2D]
    var tripDisplacement: Double
}

class TripInfo {
    
    //Define payment parameters
    let localPopnDensity: Double = 312.3 //people/km^2
    let referencePopnDensity: Double = 1565.0 //people/km^2
    var popnDesnityFactor: Double!
    let drivingModes: [String] = ["stopped", "residential", "city", "county", "highway"]
    var currentDrivingMode: String!
    var previousDrivingMode: String!
    var maxImpressionsPerHour: [Double] = [414, 1_656, 2_070, 600, 1_311] //[parked || stopped, residential drive, city drive, county drive, highway drive]
    let driveModeLowerSpeedLimit: [Double] = [0.0, 5.0, 50.0, 80.0, 100.0, 300.0]
    let averageItemCost: Double = 8.00
    let adImpressionPercentage: Double = 0.29
    let positiveImpressionPercentage: Double = 0.10
    let royaltyFromAdvertiser: Double = 0.10
    let royaltyFromDriver: Double = 0.20
    
    var totalTripPayment: Double = 0.0
    var currentRate: Double = 0.0
    
    //Define parameters essential to payment calc.
    var previousTimeSeconds: Double = 0.0
    var currentTimeSeconds: Double = 0.0
    var timeSpentInMode: Double = 0.0
    
    var currentDateTime: Int = 0
    var previousDateTime: Int = 0
    
    var currentLocation: CLLocationCoordinate2D!
    var previousLocation: CLLocationCoordinate2D!
    
    var incrimentalDisplacement: Double = 0.0
    var tripDisplacement: Double = 0.0
    
    var velocity: Double = 0.0
    
    var advertisersArray: [Advertiser] = []
    var advertiserLocations: [[CLLocationCoordinate2D]] = []
    var distanceFromAdvertisers: [[Double]] = []
    
    //Data storage
    var paymentFromAdvertisers: [Double] = []
    var tripPath: [CLLocationCoordinate2D] = []
    var startTimeStamp: TimeStamp!
    var stopTimeStamp: TimeStamp!
    
    var storageCell: TripInfoForMem!
    
    //Class methods
    init(advertisers: [Advertiser], startingPosition: CLLocationCoordinate2D) {
        advertisersArray = advertisers
        popnDesnityFactor = localPopnDensity / referencePopnDensity
        for index in 0...(maxImpressionsPerHour.count - 1) {
            maxImpressionsPerHour[index] *= popnDesnityFactor
        }
        for index in 0...(advertisersArray.count - 1) {
            advertiserLocations.append(advertisersArray[index].locations)
            paymentFromAdvertisers.append(0.0)
        }
        previousLocation = startingPosition
    }
    
    func calculateCurrentTime() {
        let currentDate = NSDate()
        currentDateTime = currentDate.hour() * 60 + currentDate.minute()
    }
    
    func calculateDisplacement() {
        if previousLocation == nil {
            previousLocation = currentLocation
        }
        incrimentalDisplacement = calcDistance(currentLocation, locationB: previousLocation)
        tripDisplacement += incrimentalDisplacement
    }
    
    func calculateVelocity() {
        currentTimeSeconds = CACurrentMediaTime()
        velocity = incrimentalDisplacement / (currentTimeSeconds - previousTimeSeconds) * 3.6
    }
    
    func calculateDistanceFromAdvertiser() {
        for index in 0...(advertiserLocations.count - 1) {
            var temporaryLocationArray: [Double] = []
            for newIndex in 0...(advertiserLocations[index].count - 1) {
                let distanceFromAdvertiser = calcDistance(currentLocation, locationB: advertiserLocations[index][newIndex])
                temporaryLocationArray.append(distanceFromAdvertiser)
            }
            distanceFromAdvertisers.append(temporaryLocationArray)
        }
    }
    
    func calculateHourlyFactor() -> Double {
        self.calculateCurrentTime()
        var hourlyFactor: Double!
        if (currentDateTime >= 0 && currentDateTime < 420) {
            hourlyFactor = (5.102040816e-6) * Double(currentDateTime * currentDateTime) + 0.1
        } else if (currentDateTime >= 780 && currentDateTime < 960) {
            hourlyFactor = (61.72839506e-6) * pow(Double(currentDateTime) - 630.0, 2.0) + 0.5
        } else if (currentDateTime >= 420 && currentDateTime < 630) || (currentDateTime >= 720 && currentDateTime < 780) || (currentDateTime >= 960 && currentDateTime < 1080) {
            hourlyFactor = 0.1
        } else if (currentDateTime >= 780 && currentDateTime < 960) {
            hourlyFactor = (61.72839506e-6) * pow(Double(currentDateTime) - 870.0, 2.0) + 0.5
        } else if (currentDateTime > 1080) {
            hourlyFactor = (0.771604938e-6) * pow(Double(currentDateTime) - 1440, 2.0) + 0.1
        }
        return hourlyFactor
    }
    
    func secretSauce(location: CLLocationCoordinate2D) {
        currentLocation = location
        
        self.calculateCurrentTime()
        self.calculateDisplacement()
        self.calculateVelocity()
        self.calculateDistanceFromAdvertiser()

        
        //determine driving mode
        let timeDifference = currentTimeSeconds - previousTimeSeconds
        
        var thisIndex: Int = 0
        var verifiedIndex: Int = 0
        
        for index in 0...(drivingModes.count - 1) {
            if velocity >= driveModeLowerSpeedLimit[index] && velocity < driveModeLowerSpeedLimit[index + 1] {
                thisIndex = index
            }
        }
        
        if previousDrivingMode == nil || tripDisplacement <= 150.0 {
            previousDrivingMode = drivingModes[thisIndex]
            currentDrivingMode = drivingModes[thisIndex]
            //timeSpentInMode = 7.0
        }
        
        if previousDrivingMode == drivingModes[thisIndex] {
            timeSpentInMode += timeDifference
        } else {
            previousDrivingMode = drivingModes[thisIndex]
            timeSpentInMode = 0.0
        }
        
        if timeSpentInMode >= 7.0 {
            currentDrivingMode = previousDrivingMode
            verifiedIndex = thisIndex
        }
        
        let hourlyImpressionsFactor = localPopnDensity / referencePopnDensity * (maxImpressionsPerHour[verifiedIndex] * calculateHourlyFactor())
        let incrimentalPaymentFactor : Double = (1 - royaltyFromDriver) * hourlyImpressionsFactor * royaltyFromAdvertiser * averageItemCost
        var distanceFactor: Double = 1.0
        
        totalTripPayment = 0.0
        
        for index in 0...(advertiserLocations.count - 1) {
            
            for newIndex in 0...(advertiserLocations[index].count - 1) {
                if distanceFromAdvertisers[index][newIndex] <= advertisersArray[index].criticalRadius {
                    distanceFactor = 1.0
                } else {
                    distanceFactor = 1.0 / (distanceFromAdvertisers[index][newIndex] - advertisersArray[index].criticalRadius - 1.0)
                }
                currentRate = hourlyImpressionsFactor * incrimentalPaymentFactor * distanceFactor * (currentTimeSeconds - previousTimeSeconds) / 3_600
                let incrimentalPayment = currentRate
                paymentFromAdvertisers[index] += incrimentalPayment
            }
            totalTripPayment += paymentFromAdvertisers[index]
        }
        
        previousLocation = currentLocation
        previousTimeSeconds = currentTimeSeconds
    }
    
    func makeTimeStamp() -> TimeStamp {
        let currentDate = NSDate()
        let timeStamp = TimeStamp(year: currentDate.year(), month: currentDate.month(), day: currentDate.day(), hour: currentDate.hour(), minute: currentDate.minute())
        return timeStamp
    }
    
    func startNewTrip() {
        startTimeStamp = makeTimeStamp()
        previousTimeSeconds = CACurrentMediaTime()
        currentTimeSeconds = CACurrentMediaTime()
    }
    
    func save() {
        stopTimeStamp = makeTimeStamp()
        storageCell = TripInfoForMem(startTimeStamp: startTimeStamp, stopTimeStamp: stopTimeStamp, paymentFromAdvertisers: paymentFromAdvertisers, tripPath: tripPath, tripDisplacement: tripDisplacement)
    }
    
    func resetForNewTrip() {
        incrimentalDisplacement = 0.0
        tripDisplacement = 0.0
        tripPath.removeAll()
        
        currentLocation = nil
        previousLocation = nil
        
        currentDateTime = 0
        previousDateTime = 0
        
        previousTimeSeconds = 0.0
        currentTimeSeconds = 0.0
        timeSpentInMode = 0.0
        
        totalTripPayment = 0.0
        for index in 0...(paymentFromAdvertisers.count - 1) {
            paymentFromAdvertisers[index] = 0.0
        }
        
        storageCell = nil
    }
    
}