//
//  dashboard.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

/*
 37.35187, -122.06703
 37.33352, -122.04171
 37.37084, -122.11132
 37.35822, -122.13132
*/

import UIKit
import CoreLocation
import MapKit

class dashboard : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var displacementLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    var startState: Bool = false
    var previousStartState: Bool = false
    @IBOutlet weak var startStopButton: UIButton!
    @IBAction func startStopButtonPressed(sender: UIButton) {
        switch startState {
        case true:
            self.startStopButton.setTitle("start", forState: .Normal)
            startState = false
        case false:
            self.startStopButton.setTitle("stop", forState: .Normal)
            startState = true
        }
        
    }
    @IBOutlet var paymentLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    var center: CLLocationCoordinate2D!
    var previousLocation: CLLocationCoordinate2D!
    var integratedDisplacement: Double = 0.0
    
    var currentTrip: TripInfo!
    var tripLogArray: [CLLocation] = []
    var currentTripLog: [CLLocationCoordinate2D] = []
    let businessCoordinatesArray: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(37.35187, -122.06703), CLLocationCoordinate2DMake(37.33352, -122.04171), CLLocationCoordinate2DMake(37.37084, -122.11132), CLLocationCoordinate2DMake(37.35822, -122.13132)]
    let businessNameArray: [String] = ["Joe's Diner", "Corner Cafe", "Steakhouse", "Flower Boutique"]
    let appleLocation = CLLocationCoordinate2D(latitude: 37.33159558, longitude: -122.03045365)
    
    let advertiserNameArray: [String] = ["Green Bean Cafe", "Lone Star Steakhouse", "Tequila Bobs", "Starbucks", "Pizza Pizza"]
    let advertiserDescriptionArray: [String] = ["Local hipster cafe", "Huuuge steaks. Theyre great.", "The name says it all", "White people cafe", "Shit on bread"]
    let advertiserImageNameArray: [String] = ["greenBeanLogo", "loneStarLogo", "tequilaBobsLogo", "starbucksLogo", "pizzaPizzaLogo"]
    let greenBeanLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.3053082, longitude: -83.0625892), CLLocationCoordinate2D(latitude: 42.3173896, longitude: -83.0386166)]
    let tequilaBobsLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.3192747, longitude: -83.0383686)]
    let loneStarLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.2599018, longitude: -82.966819)]
    let starbucksLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.2861807, longitude: -83.0566867),
        CLLocationCoordinate2D(latitude: 42.317330, longitude: -83.039255),
        CLLocationCoordinate2D(latitude: 42.274670, longitude: -83.003556),
        CLLocationCoordinate2D(latitude: 42.254966, longitude: -82.963104),
        CLLocationCoordinate2D(latitude: 42.255018, longitude: -83.001405)]
    let pizzaPizzaLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.305488, longitude: -83.061076),
        CLLocationCoordinate2D(latitude: 42.317762, longitude: -83.038797),
        CLLocationCoordinate2D(latitude: 42.297389, longitude: -83.017336)]
    
    let greenBeanAnnotation: MKPointAnnotation = MKPointAnnotation()
    let loneStarAnnotation: MKPointAnnotation = MKPointAnnotation()
    let tequilaBobsAnnotation: MKPointAnnotation = MKPointAnnotation()
    let starbucksAnnotation: MKPointAnnotation = MKPointAnnotation()
    let pizzaPizzaAnnotation: MKPointAnnotation = MKPointAnnotation()
    
    let greenBean: Advertiser = Advertiser()
    let loneStar: Advertiser = Advertiser()
    let tequilaBobs: Advertiser = Advertiser()
    let startbucks: Advertiser = Advertiser()
    let pizzaPizza: Advertiser = Advertiser()
    
    let zoom: Double = 0.015
    
    var currentIndex: Int = 0
    var otherIndex: Int = 0
    
    var previousTime: Double = 0.0
    
    
    
    
    
    override func viewDidLoad() {
        
        currentViewController = 0
        print(currentViewController)
        
        super.viewDidLoad()
        
        self.startStopButton.setTitle("start", forState: .Normal)
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.mapView.showsCompass = true
        self.mapView.mapType = currentUser.preferedMapType
        
    //setup initial view of map
        
        self.locationManager.startUpdatingLocation()
        while self.locationManager.location?.coordinate == nil {
        }
        
        center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
        
        previousLocation = center
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        self.mapView.setRegion(region, animated: true)
        
    //Create advertiser instances and annotations on map
        
        for index in 0...(businessCoordinatesArray.count - 1) {
            self.mapView.addOverlay(MKCircle(centerCoordinate: businessCoordinatesArray[index], radius: 1_200))
        }
        
        let advertiserArray: [Advertiser] = [greenBean, loneStar, tequilaBobs, startbucks, pizzaPizza]
        let advertiserLocationsArray: [[CLLocationCoordinate2D]] = [greenBeanLocations, loneStarLocations, tequilaBobsLocations, starbucksLocations, pizzaPizzaLocations]
        var annotationArray: [MKPointAnnotation] = [] //[greenBeanAnnotation, loneStarAnnotation, tequilaBobsAnnotation, starbucksAnnotation, pizzaPizzaAnnotation]

        for index in 0...(advertiserNameArray.count - 1) {
            advertiserArray[index].name = advertiserNameArray[index]
            advertiserArray[index].descirption = advertiserDescriptionArray[index]
            advertiserArray[index].logo = UIImage(named: advertiserImageNameArray[index])
            advertiserArray[index].locations = advertiserLocationsArray[index]
            for newIndex in 0...(advertiserArray[index].locations.count - 1) {
                annotationArray.append(MKPointAnnotation())
                
                annotationArray[otherIndex].coordinate = advertiserArray[index].locations[newIndex]
                annotationArray[otherIndex].title = advertiserArray[index].name
                annotationArray[otherIndex].subtitle = advertiserArray[index].descirption
                currentIndex = index

                self.mapView.addAnnotation(annotationArray[otherIndex])
                self.mapView.addOverlay(MKCircle(centerCoordinate: advertiserArray[index].locations[newIndex], radius: 1_200))

                print("Other Index: \(otherIndex)")
                otherIndex += 1
            }
        }
        
        currentTrip = TripInfo(advertisers: advertiserArray, startingPosition: previousLocation)
        
    //Add pan gesture recognizer for menu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    
    //display annotations on map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let resuseID = (annotation.title!)!
        var imageName: String = "business Pin"
        for index in 0...(self.advertiserNameArray.count - 1) {
            if resuseID == advertiserNameArray[index] {
                imageName = advertiserImageNameArray[index]
            }
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(resuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: resuseID)
            annotationView?.image = UIImage(named: imageName)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    
    
    //centers map on current location; calcaulte distance, displacement and velocity; calculate positions for polyLine overlay
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startState != previousStartState && startState == true {
            currentTrip.startNewTrip()
        } else if startState != previousStartState && startState == false {
            currentTrip.save()
            currentUser.tripLog.append(currentTrip.storageCell)
            
            currentTripLog.removeAll()
            currentTrip.resetForNewTrip()
        }
        
        
        let location = locations.last
        let currentTime = CACurrentMediaTime()
        
        center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        self.mapView.setRegion(region, animated: true)
        
        //var businessDistance: Double!
        
        let advertiserArray: [Advertiser] = [greenBean, loneStar, tequilaBobs, startbucks, pizzaPizza]
        let advertiserLocationsArray: [[CLLocationCoordinate2D]] = [greenBeanLocations, loneStarLocations, tequilaBobsLocations, starbucksLocations, pizzaPizzaLocations]
        
        for index in 0...(advertiserArray.count - 1) {
            if advertiserArray[index].locations == nil {
                advertiserArray[index].locations = advertiserLocationsArray[index]
            }
            for newIndex in 0...(advertiserArray[index].locations.count - 1) {
                //businessDistance = calcDistance(center, locationB: advertiserArray[index].locations[newIndex])
            }
        }
        
        let displacement = calcDistance(center, locationB: previousLocation)
        integratedDisplacement += displacement
        
        let velocity = displacement / (currentTime - previousTime) * 3.6
        
        
        
        if startState == true {
            
            currentTrip.secretSauce(center)
            
            currentTripLog.append(locations.last!.coordinate as CLLocationCoordinate2D)
            if currentTripLog.count > 1 {
                    let sourceIndex = currentTripLog.count - 2
                    let newIndex = currentTripLog.count - 1
                    
                    let sourceCoordinate = currentTripLog[sourceIndex]
                    let newCoordinate = currentTripLog[newIndex]
                    var a = [newCoordinate, sourceCoordinate]

                    let polyLine = MKPolyline(coordinates: &a , count: a.count)
                    mapView.addOverlay(polyLine)
                }
            self.distanceLabel.text = currentTrip.currentDrivingMode
            self.displacementLabel.text = "Displacement: \(roundDouble(currentTrip.incrimentalDisplacement, decimalPlaces: 2))m"
            self.velocityLabel.text = "Velocity: \(roundDouble(currentTrip.velocity, decimalPlaces: 2))km/h"
        } else {
            self.distanceLabel.text = "Distance: 0m"
            self.displacementLabel.text = "Displacement: 0m"
            self.velocityLabel.text = "Velocity: \(roundDouble(velocity, decimalPlaces: 2))km/h"
        }
        
        previousLocation = center
        previousTime = currentTime
        previousStartState = startState
        //self.locationManager.stopUpdatingLocation()
        
    }

    
    
    //render circle and polyline overlays
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor(hex: 0x4AD5C6).colorWithAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.clearColor()
            circleRenderer.lineWidth = 1
            return circleRenderer
        } else {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = UIColor(hex: 0x4AD5C6)
            polyLineRenderer.lineWidth = 5
            polyLineRenderer.lineCap = CGLineCap.Round
            return polyLineRenderer
        }
        
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //display statusBar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    
    
    //animate status bar back on screen
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    
    
    
}


       