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
import CoreMotion
import MapKit
//import Firebase


let inSimulation = false


class dashboard : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView = MKMapView()
    
    var headerView = UIView()
    var headerLabel = UILabel()
    var backgroundImage = UIImageView()
    var slideMenuIcon = UIImageView()
    var slideMenuButton = UIButton()
    var paymentIndicatorLabel = UILabel()
    var paymentIndicatorSubLabel = UILabel()
    var beginAndEndButton = UIImageView()
    var beginAndEndButtonOverlay = UIButton()
    var locateMeIcon = UIImageView()
    
    var pinchView = UIView()
    let pinchRec = UIPinchGestureRecognizer()
    
    var startState: Bool = false
    var previousStartState: Bool = false
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    
    var center: CLLocationCoordinate2D!
    var previousLocation: CLLocationCoordinate2D!
    var integratedDisplacement: Double = 0.0
    var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var currentTrip: TripInfo!
    var tripLogArray: [CLLocation] = []
    var currentTripLog: [CLLocationCoordinate2D] = []
    
    let businessCoordinatesArray: [[CLLocationCoordinate2D]] = [[CLLocationCoordinate2DMake(37.35187, -122.06703)], [CLLocationCoordinate2DMake(37.33352, -122.04171)], [CLLocationCoordinate2DMake(37.37084, -122.11132)], [CLLocationCoordinate2DMake(37.35822, -122.13132)]]
    let businessNameArray: [String] = ["Joe's Diner", "Corner Cafe", "Steakhouse", "Flower Boutique"]
    let appleLocation = CLLocationCoordinate2D(latitude: 37.33159558, longitude: -122.03045365)
    
    let joesDinerAnnotation: MKPointAnnotation = MKPointAnnotation()
    let cornerCafeAnnotation: MKPointAnnotation = MKPointAnnotation()
    let SteakhouseAnnotation: MKPointAnnotation = MKPointAnnotation()
    let flowerBoutiqueAnnotation: MKPointAnnotation = MKPointAnnotation()
    let appleAnnotation: MKPointAnnotation = MKPointAnnotation()
    
    let joesDiner: Advertiser = Advertiser()
    let cornerCafe: Advertiser = Advertiser()
    let Steakhouse: Advertiser = Advertiser()
    let flowerBoutique: Advertiser = Advertiser()

    let advertiserNameArray: [String] = ["Green Bean Cafe", "Lone Star Steakhouse", "Tequila Bobs", "Starbucks", "Pizza Pizza"]
    let advertiserDescriptionArray: [String] = ["Local hipster cafe", "Huuuge steaks. Theyre great.", "The name says it all", "White people cafe", "Shit on bread"]
    let advertiserImageNameArray: [String] = ["greenBeanLogo", "loneStarLogo", "tequilaBobsLogo", "starbucksLogo", "pizzaPizzaLogo"]
    let greenBeanLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.3053082, longitude: -83.0625892), CLLocationCoordinate2D(latitude: 42.3173896, longitude: -83.0386166),
        CLLocationCoordinate2D(latitude: 43.5668348, longitude: -81.7004942),
        CLLocationCoordinate2D(latitude: 43.5520317, longitude: -81.7035412)]
    let tequilaBobsLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.3192747, longitude: -83.0383686)]
    let loneStarLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.2599018, longitude: -82.966819)]
    let starbucksLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 42.2861807, longitude: -83.0566867),
        CLLocationCoordinate2D(latitude: 42.317330, longitude: -83.039255),
        CLLocationCoordinate2D(latitude: 42.274670, longitude: -83.003556),
        CLLocationCoordinate2D(latitude: 42.254966, longitude: -82.963104),
        CLLocationCoordinate2D(latitude: 42.255018, longitude: -83.001405),
        CLLocationCoordinate2D(latitude: 43.560802, longitude: -81.699872)]
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
    
    var altitude: Double = 0
    let altitudeArray: [Double] = [1_000, 1_100, 1_200, 1_400, 1_600]
    
    var currentIndex: Int = 0
    var otherIndex: Int = 0
    
    var previousTime: Double = 0.0
    
    var currentHeading: Double = 0.0
    var currentPitch: Double = 0.0
    
    let filterResolution: Int = 7
    var previousPitch: [Double] = []
    
    var userFreeToMoveMap = false
    
    override func viewDidLoad() {
        
        print("---- in dashboard view controller ----")
        
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.mapView.frame = CGRectMake(0, self.view.bounds.height / 3.0, self.view.bounds.width, self.view.bounds.height * 2.0 / 3.0)
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = CLActivityType.AutomotiveNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        
        self.mapView.showsUserLocation = true
        self.mapView.showsCompass = true
        self.mapView.mapType = currentUser.preferedMapType
        self.mapView.showsBuildings = true
        self.mapView.pitchEnabled = true
        self.view.addSubview(mapView)
        
        /*
        self.backgroundImage.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height / 3.0 + (self.view.bounds.height * 0.02273863068))
        self.backgroundImage.image = UIImage(named: "white_header_background_with_shade")
        self.view.addSubview(backgroundImage)
        */
        
        self.headerView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height / 3.0)
        self.headerView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(self.headerView)
        
        let iconSize: CGFloat = self.view.frame.height * 0.02464467766
        
        let headerLabelWidth: CGFloat = self.view.frame.width / 3
        let headerLabelHeight: CGFloat = headerLabelWidth * 95.0 / 180.0
        self.headerLabel.frame = CGRectMake((self.view.frame.width / 2.0) - (headerLabelWidth / 2.0), self.view.frame.height / 12.0 - 20, headerLabelWidth, headerLabelHeight)
        self.headerLabel.text = "eigen"
        self.headerLabel.textAlignment = NSTextAlignment.Center
        self.headerLabel.textColor = UIColor.whiteColor()
        self.headerLabel.font = UIFont(name: "AvenirNext-Regular", size: 36.9)
        self.view.addSubview(headerLabel)
        
        let slideMenuIconY = self.headerLabel.frame.origin.y + self.headerLabel.frame.size.height / 2.0 - iconSize / 2.0 - 5
        self.slideMenuIcon.frame = CGRectMake(self.view.frame.width * 0.055556, slideMenuIconY, iconSize, iconSize)
        self.slideMenuIcon.image = UIImage(named: "slide_menu_icon")
        self.view.addSubview(slideMenuIcon)
        
        let sMBES: CGFloat = 10.0
        self.slideMenuButton.frame = CGRectMake(self.slideMenuIcon.frame.origin.x - sMBES, self.slideMenuIcon.frame.origin.y - sMBES, self.slideMenuIcon.frame.width + (2 * sMBES), self.slideMenuIcon.frame.height + (2 * sMBES))
        self.slideMenuButton.titleLabel?.text = ""
        self.slideMenuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(slideMenuButton)
        
        self.paymentIndicatorLabel.text = "$12.09"
        self.paymentIndicatorLabel.font = UIFont(name: "AvenirNext-Regular", size: 58.0)
        self.paymentIndicatorLabel.textAlignment = NSTextAlignment.Center
        self.paymentIndicatorLabel.textColor = UIColor.whiteColor()
        self.paymentIndicatorLabel.frame = CGRectMake(0, self.view.frame.height / 6.0 - 5, self.view.frame.width, 60.0)
        self.view.addSubview(paymentIndicatorLabel)
        
        self.paymentIndicatorSubLabel.text = "total earnings this trip"
        self.paymentIndicatorSubLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        self.paymentIndicatorSubLabel.textAlignment = NSTextAlignment.Center
        self.paymentIndicatorSubLabel.textColor = UIColor.whiteColor()
        let paymentIndicatorSubLabelY = self.paymentIndicatorLabel.frame.origin.y + self.paymentIndicatorLabel.frame.size.height
        self.paymentIndicatorSubLabel.frame = CGRectMake(0, paymentIndicatorSubLabelY, self.view.frame.width, 15.0)
        self.view.addSubview(paymentIndicatorSubLabel)
        
        let beginAndEndButtonWidth = self.view.frame.width / 2.0
        let beginAndEndButtonHeight = beginAndEndButtonWidth * 105 / 380
        let beginAndEndButtonX = (self.view.frame.width - beginAndEndButtonWidth) / 2.0
        let beginAndEndButtonY = self.view.frame.height * 11.0 / 12.0 - beginAndEndButtonHeight
        self.beginAndEndButton.frame = CGRectMake(beginAndEndButtonX, beginAndEndButtonY, beginAndEndButtonWidth, beginAndEndButtonHeight)
        self.beginAndEndButton.image = UIImage(named: "begin_trip_button")
        self.view.addSubview(beginAndEndButton)
        
        self.beginAndEndButtonOverlay.frame = self.beginAndEndButton.frame
        self.view.addSubview(beginAndEndButtonOverlay)
        self.beginAndEndButtonOverlay.addTarget(self, action: #selector(dashboard.buttonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let locateMeIconSize: CGFloat = self.view.frame.height / 12
        self.locateMeIcon.frame = CGRect(x: self.view.frame.width / 18, y: self.backgroundImage.frame.height, width: locateMeIconSize, height: locateMeIconSize)
        self.locateMeIcon.image = UIImage(named: "locate_me_icon")
        self.view.addSubview(locateMeIcon)
        self.locateMeIcon.hidden = true
        
        //setup initial view of map
        self.locationManager.startUpdatingLocation()
        while self.locationManager.location?.coordinate == nil {}
        
        center = self.locationManager.location?.coordinate
        print(center)
        previousLocation = center
        
        let camera = MKMapCamera(lookingAtCenterCoordinate: center, fromDistance: altitudeArray[0], pitch: 0, heading: 0)
        self.mapView.setCamera(camera, animated: false)
        self.mapView.setCenterCoordinate(center, animated: true)
        
        //Create advertiser instances and annotations on map
        let advertiserArray: [Advertiser]!
        if inSimulation == true {
            advertiserArray = [joesDiner, cornerCafe, Steakhouse, flowerBoutique]
            
            let advertiserLocationsArray: [[CLLocationCoordinate2D]] = businessCoordinatesArray
            var annotationArray: [MKPointAnnotation] = []
            
            for index in 0...(businessNameArray.count - 1) {
                advertiserArray[index].name = businessNameArray[index]
                //advertiserArray[index].descirption = advertiserDescriptionArray[index]
                let advLogoImage = UIImage(named: advertiserImageNameArray[index])
                advertiserArray[index].logo = UIImage.scaleImageToScale(advLogoImage!, scale: 0.13)
                advertiserArray[index].locations = advertiserLocationsArray[index]
                for newIndex in 0...(advertiserArray[index].locations.count - 1) {
                    annotationArray.append(MKPointAnnotation())
                    
                    annotationArray[otherIndex].coordinate = advertiserArray[index].locations[newIndex]
                    annotationArray[otherIndex].title = advertiserArray[index].name
                    annotationArray[otherIndex].subtitle = "cool beans, brah"
                    currentIndex = index
                    
                    self.mapView.addAnnotation(annotationArray[otherIndex])
                    self.mapView.addOverlay(MKCircle(centerCoordinate: advertiserArray[index].locations[newIndex], radius: 1_200))
                    
                    otherIndex += 1
                }
            }
        } else {
            advertiserArray = [greenBean, loneStar, tequilaBobs, startbucks, pizzaPizza]
            
            let advertiserLocationsArray: [[CLLocationCoordinate2D]] = [greenBeanLocations, loneStarLocations, tequilaBobsLocations, starbucksLocations, pizzaPizzaLocations]
            var annotationArray: [MKPointAnnotation] = [] //[greenBeanAnnotation, loneStarAnnotation, tequilaBobsAnnotation, starbucksAnnotation, pizzaPizzaAnnotation]
            
            
            for index in 0...(advertiserNameArray.count - 1) {
                advertiserArray[index].name = advertiserNameArray[index]
                advertiserArray[index].descirption = advertiserDescriptionArray[index]
                let advLogoImage = UIImage(named: advertiserImageNameArray[index])
                advertiserArray[index].logo = ResizeImage(advLogoImage!, targetSize: CGSize(width: 0.1, height: 0.1))
                advertiserArray[index].locations = advertiserLocationsArray[index]
                for newIndex in 0...(advertiserArray[index].locations.count - 1) {
                    annotationArray.append(MKPointAnnotation())
                    
                    annotationArray[otherIndex].coordinate = advertiserArray[index].locations[newIndex]
                    annotationArray[otherIndex].title = advertiserArray[index].name
                    annotationArray[otherIndex].subtitle = advertiserArray[index].descirption
                    currentIndex = index
                    
                    self.mapView.addAnnotation(annotationArray[otherIndex])
                    self.mapView.addOverlay(MKCircle(centerCoordinate: advertiserArray[index].locations[newIndex], radius: 1_200))
                    
                    otherIndex += 1
                }
            }
        }
        currentUser.advertisers = advertiserArray
        
        currentTrip = TripInfo(advertisers: advertiserArray, startingPosition: previousLocation)
        
        //Add pan gesture recognizers
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(dashboard.pinchedView(_:)))
        self.view.addGestureRecognizer(pinch)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    //called when user touches screen; only important for when user touches mapView
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let tempPoint = touch.locationInView(self.view)
        let point =  (tempPoint.x, tempPoint.y)
        switch point{
        //user touches locateMeIcon when userFreeToMoveMap == true
        case let (x, y) where self.locateMeIcon.frame.origin.x...(self.locateMeIcon.frame.origin.x + self.locateMeIcon.frame.width) ~= x && self.locateMeIcon.frame.origin.y...(self.locateMeIcon.frame.origin.y + self.locateMeIcon.frame.height) ~= y: //&& userFreeToMoveMap == true:
            self.locateMeIcon.hidden = true
            self.userFreeToMoveMap = false
            print("case deus")
            
        default:
            break
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let tempPoint = touch.locationInView(self.view)
        let point = (tempPoint.x, tempPoint.y)
        switch point {
        //user touch moves on map case
        case let (x, y) where self.mapView.frame.origin.x...self.mapView.frame.width ~= x && self.mapView.frame.origin.y...self.view.frame.height ~= y:
            if userFreeToMoveMap == false && startState == false{
                userFreeToMoveMap = true
            } else if userFreeToMoveMap == true && startState == false {
                self.locateMeIcon.hidden = false
            } else if startState == false {
                self.locateMeIcon.hidden = true
            }
            print("case uno")
        default:
            break
        }
    }
    
    //centers map on current location; calcaulte distance, displacement and velocity; calculate positions for polyLine overlay
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if startState != previousStartState && startState == true {
            currentTrip.startNewTrip()
            let camera = MKMapCamera(lookingAtCenterCoordinate: center, fromDistance: altitude, pitch: 60, heading: currentHeading)
            self.mapView.setCamera(camera, animated: true)
        } else if startState != previousStartState && startState == false {
            currentTrip.tripPath = currentTripLog
            currentTrip.save()
            currentUser.tripLog.append(currentTrip.storageCell)
            
            currentTripLog.removeAll()
            currentTrip.resetForNewTrip()
            
            let baseCamera = MKMapCamera(lookingAtCenterCoordinate: center, fromDistance: altitudeArray[0], pitch: 0, heading: 0)
            self.mapView.setCamera(baseCamera, animated: true)
        }
        
        
        let location = locations.last
        let currentTime = CACurrentMediaTime()
        
        for index in 0...currentTrip.drivingModes.count - 1 {
            if currentTrip.currentDrivingMode != nil && currentTrip.drivingModes[index] == currentTrip.currentDrivingMode {
                altitude = altitudeArray[index]
            }
        }
        
        center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)

        let advertiserArray: [Advertiser]!
        let advertiserLocationsArray: [[CLLocationCoordinate2D]]!
        if inSimulation == false {
            advertiserArray = [greenBean, loneStar, tequilaBobs, startbucks, pizzaPizza]
            advertiserLocationsArray = [greenBeanLocations, loneStarLocations, tequilaBobsLocations, starbucksLocations, pizzaPizzaLocations]
        } else {
            advertiserArray = [joesDiner, cornerCafe, Steakhouse, flowerBoutique]
            advertiserLocationsArray = businessCoordinatesArray
        }
        
        for index in 0...(advertiserArray.count - 1) {
            if advertiserArray[index].locations == nil {
                advertiserArray[index].locations = advertiserLocationsArray[index]
            }
        }
        
        let displacement = calcDistance(center, locationB: previousLocation)
        integratedDisplacement += displacement

        if startState == true {
            //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: altitude, longitudeDelta: zoom))
            //self.mapView.setRegion(region, animated: true)
            
            
            self.mapView.setCenterCoordinate(center, animated: true)
            
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
            self.paymentIndicatorLabel.text = "$\(roundDouble(currentTrip.totalTripPayment, decimalPlaces: 2))"
        } else {
            if userFreeToMoveMap == false {
                let camera = MKMapCamera(lookingAtCenterCoordinate: center, fromDistance: altitudeArray[0], pitch: 0, heading: 0)
                print(altitude)
                self.mapView.setCamera(camera, animated: true)
            }
        }
        
        previousLocation = center
        previousTime = currentTime
        previousStartState = startState
    }
    
    //action when user presses start/stop button
    func buttonPressed(sender: UIButton) {
        switch startState {
        case true:
            self.mapView.scrollEnabled = true
            self.mapView.zoomEnabled = true
            self.mapView.pitchEnabled = true
            self.mapView.rotateEnabled = true
            
            self.beginAndEndButton.image = UIImage(named: "begin_trip_button")
            UIApplication.sharedApplication().idleTimerDisabled = false
            startState = false
        case false:
            self.mapView.scrollEnabled = false
            self.mapView.zoomEnabled = false
            //self.mapView.pitchEnabled = false
            self.mapView.rotateEnabled = false
            self.beginAndEndButton.image = UIImage(named: "end_trip_button")
            UIApplication.sharedApplication().idleTimerDisabled = true
            startState = true
        }
    }
    
    //update heading of mapView
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading.trueHeading
        if(startState == true) {
            let camera = MKMapCamera(lookingAtCenterCoordinate: center, fromDistance: altitude, pitch: 60, heading: currentHeading)
            self.mapView.setCamera(camera, animated: true)
        }
    }
    
    //display annotations on map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let resuseID = (annotation.title!)!
        var imageName: String = "businessPin"
        
        if inSimulation == false {
            for index in 0...(self.advertiserNameArray.count - 1) {
                if resuseID == advertiserNameArray[index] {
                    imageName = advertiserImageNameArray[index]
                }
            }
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(resuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: resuseID)
            let tempUIImageHolder = UIImage(named: imageName)
            annotationView?.image = UIImage.scaleImageToScale(tempUIImageHolder!, scale: 0.13)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    //render circle and polyline overlays
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor(hex: 0x4AD5C6).colorWithAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.whiteColor()
            circleRenderer.lineWidth = 2
            return circleRenderer
        } else {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = UIColor(hex: 0xC669EE)
            polyLineRenderer.lineWidth = 5
            polyLineRenderer.lineCap = CGLineCap.Round
            return polyLineRenderer
        }
        
    }
    
    //error printout
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    //memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //color of status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //display statusBar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //animate status bar back on screen
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        print("here")
        self.locateMeIcon.hidden = false
    }
    
    
    func resetToCurrentPositionView() {
        
    }
    
}










       