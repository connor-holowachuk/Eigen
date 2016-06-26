//
//  profile.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class profile : UIViewController {
    
    var headerView = UIView()
    var headerLabel = UILabel()
    var profileImage = UIImageView()
    var slideMenuIcon = UIImageView()
    var slideMenuButton = UIButton()
    
    var nameLabel = UILabel()
    var nameSubLabel = UILabel()
    var emailLabel = UILabel()
    var emailSubLabel = UILabel()
    var carLabel = UILabel()
    var carSubLabel = UILabel()
    var streetAdressLabel = UILabel()
    var cityAdressLabel = UILabel()
    var countryLabel = UILabel()
    var adressSubLabel = UILabel()
    
    var mapViewBackShade = UIImageView()
    var mapView = MKMapView()
    
    
    override func viewDidLoad() {
        
        print("---- in profile view controller ----")
        
        self.headerView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height / 3.0)
        self.headerView.backgroundColor = UIColor.eigenBlueColor()
        self.view.addSubview(self.headerView)
        
        let iconSize: CGFloat = self.view.frame.height * 0.02954
        
        let headerTextHeight = self.view.frame.height * 0.057
        let headerLabelWidth: CGFloat = self.view.frame.width * 2.0 / 3
        let headerLabelExtraSpace: CGFloat = 3.0
        self.headerLabel.frame = CGRectMake((self.view.frame.width / 2.0) - (headerLabelWidth / 2.0), self.view.frame.height * 0.061 - headerLabelExtraSpace, headerLabelWidth, headerTextHeight + 2.0 * headerLabelExtraSpace)
        self.headerLabel.text = "profile"
        self.headerLabel.textAlignment = NSTextAlignment.Center
        self.headerLabel.textColor = UIColor.whiteColor()
        self.headerLabel.font = UIFont(name: "AvenirNext-Regular", size: headerTextHeight)
        self.view.addSubview(headerLabel)
                
        let slideMenuIconY = self.headerLabel.frame.origin.y + self.headerLabel.frame.size.height / 2.0 - iconSize / 2.0 
        self.slideMenuIcon.frame = CGRectMake(self.view.frame.width * 0.055556, slideMenuIconY, iconSize, iconSize)
        self.slideMenuIcon.image = UIImage(named: "slide_menu_icon")
        self.view.addSubview(slideMenuIcon)
        
        let sMBES: CGFloat = 10.0
        self.slideMenuButton.frame = CGRectMake(self.slideMenuIcon.frame.origin.x - sMBES, self.slideMenuIcon.frame.origin.y - sMBES, self.slideMenuIcon.frame.width + (2 * sMBES), self.slideMenuIcon.frame.height + (2 * sMBES))
        self.slideMenuButton.titleLabel?.text = ""
        self.slideMenuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(slideMenuButton)
        
        let profileImageSize = self.view.frame.height / 6.0
        self.profileImage.frame = CGRectMake((self.view.frame.width - profileImageSize) / 2.0, self.view.frame.height / 9.0 + 20, profileImageSize, profileImageSize)
        self.profileImage.image = UIImage(named: "profile_pic_test")
        self.view.addSubview(profileImage)
        
        let labelIncrimentalY = self.view.frame.height / 24.0
        
        
        let titleTextSize: CGFloat = 20.0
        let titleTextFont = UIFont(name: "AvenirNext-Regular", size: titleTextSize)
        let titleTextFontColor = UIColor(hex: 0x515151)
        
        let subTitleTextSize: CGFloat = 14.0
        let subTitleTextFont = UIFont(name: "AvenirNext-Regular", size: subTitleTextSize)
        let subTitleTextFontColor = UIColor(hex: 0xC9D0D6)
        
        let titleArray = [self.nameLabel, self.emailLabel, self.carLabel, self.streetAdressLabel, self.cityAdressLabel, self.countryLabel]
        let titleTextarray = [currentUser.name, currentUser.userName, "\(currentUser.carYear) \(currentUser.carCompany) \(currentUser.carModel)", currentUser.streetAdress, "\(currentUser.city) \(currentUser.province)  \(currentUser.postalCode)", currentUser.country]
        
        for index in 0...titleArray.count - 1{
            var currentY = self.headerView.frame.height + (labelIncrimentalY / 3.0)
            
            if index <= 3 {
                currentY += CGFloat(2 * index) * labelIncrimentalY
            } else {
                currentY += CGFloat(index + 3) * labelIncrimentalY
            }
            titleArray[index].frame = CGRectMake(0, currentY, self.view.frame.width, titleTextSize + 2.0)
            titleArray[index].text = titleTextarray[index]
            titleArray[index].font = titleTextFont
            titleArray[index].textColor = titleTextFontColor
            titleArray[index].textAlignment = NSTextAlignment.Center
            self.view.addSubview(titleArray[index])
        }
        
        let subTitleArray = [self.nameSubLabel, self.emailSubLabel, self.carSubLabel, self.adressSubLabel]
        let subTitleTextArray = ["name", "email", "car", "adress"]
        
        for index in 0...subTitleArray.count - 1 {
            var currentY = self.headerView.frame.height + (labelIncrimentalY / 3.0)
            
            if index <= 2 {
                currentY += CGFloat((2 * index) + 1) * labelIncrimentalY
            } else {
                currentY += CGFloat(9) * labelIncrimentalY
            }
            subTitleArray[index].frame = CGRectMake(0, currentY, self.view.frame.width, titleTextSize + 2.0)
            subTitleArray[index].text = subTitleTextArray[index]
            subTitleArray[index].font = subTitleTextFont
            subTitleArray[index].textColor = subTitleTextFontColor
            subTitleArray[index].textAlignment = NSTextAlignment.Center
            self.view.addSubview(subTitleArray[index])
        }
        
        let lastY = self.adressSubLabel.frame.origin.y
        
        let deltaCoord = 0.01
        let displayCenter = CLLocationCoordinate2D(latitude: 42.304529896, longitude: -83.059777193)
        let region = MKCoordinateRegion(center: displayCenter, span: MKCoordinateSpan(latitudeDelta: deltaCoord, longitudeDelta: deltaCoord))
        self.mapView.setRegion(region, animated: false)
        self.mapView.rotateEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.zoomEnabled = false
        self.mapView.pitchEnabled = false
        self.mapView.frame = CGRectMake(self.view.frame.width / 12.0, lastY + labelIncrimentalY, self.view.frame.width * 5.0 / 6.0, self.view.frame.height * 23.0 / 24.0 - (lastY + labelIncrimentalY))
        
        self.mapViewBackShade.frame = CGRectMake(self.mapView.frame.origin.x - 2, self.mapView.frame.origin.y - 2, self.mapView.frame.width + 4, self.mapView.frame.height + 12)
        self.mapViewBackShade.image = UIImage(named: "shadded_background")
        self.mapViewBackShade.alpha = 0.8
        self.view.addSubview(self.mapViewBackShade)
        
        self.view.addSubview(self.mapView)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //color of status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
}