//
//  BackTableViewController.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-28.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class BackTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    var TableArray = [String]()
    var ImagesArray = [String]()
    var BlueImagesArray = [String]()
    var profileCellHeight: CGFloat!
    var selectedScreenIndex: Int = 2
    
    override func viewDidLoad() {
        
        print("---- back table view controller loaded ----")
        super.viewDidLoad()
        TableArray = ["c holowachuk", "dashboard", "profile", "history", "settings", "help", "signOut"]
        ImagesArray = ["menu-map_icon-gray", "menu-profile_icon-gray", "menu-history_icon-gray", "menu-settings_icon-gray", "menu-help_icon-gray", "menu-signOut_icon-gray"]
        BlueImagesArray = ["menu-map_icon-blue", "menu-profile_icon-blue", "menu-history_icon-blue", "menu-settings_icon-blue", "menu-help_icon-blue"]

        
        self.tableView.registerClass(ProfileCell.self, forCellReuseIdentifier: TableArray[0])
        for index in 1...TableArray.count - 1 {
            self.tableView.registerClass(MenuCell.self, forCellReuseIdentifier: TableArray[index])
        }
        self.tableView.registerClass(MenuCell.self, forCellReuseIdentifier: "spacerCell1")
        self.tableView.registerClass(MenuCell.self, forCellReuseIdentifier: "spacerCell7")
        
        profileCellHeight = self.view.frame . height / 3.0 - statusBarHeight()
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor.eigenBlueColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.scrollEnabled = false
        return TableArray.count + 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let profileCell: ProfileCell = tableView.dequeueReusableCellWithIdentifier(TableArray[0], forIndexPath: indexPath) as! ProfileCell
            profileCell.backgroundColor = UIColor.eigenBlueColor()
            
            let profileCellTextHeight: CGFloat = self.view.frame.height / 29.0
            profileCell.ProfileLabel.textColor = UIColor.whiteColor()
            profileCell.ProfileLabel.font = UIFont(name: "HelveticaNeue-Bold", size: profileCellTextHeight)
            profileCell.ProfileLabel.textAlignment = NSTextAlignment.Left
            profileCell.ProfileLabel.text = getNameForProfileCell()
            profileCell.ProfileLabel.frame = CGRectMake(self.view.frame.width * 0.05, profileCellHeight - self.view.frame.width * 0.05 - profileCellTextHeight, self.view.frame.width * 0.9, profileCellTextHeight)
            
            let circleImageDiameter = self.view.frame.height * 0.104948
            let profileImageCircleY = profileCell.ProfileLabel.frame.origin.y - profileCellTextHeight - circleImageDiameter
            profileCell.ProfileImageCircle.image = UIImage(named: "profile_image_circle")
            profileCell.ProfileImageCircle.frame = CGRectMake(profileCell.ProfileLabel.frame.origin.x, profileImageCircleY, circleImageDiameter, circleImageDiameter)
            
            let imageToCircleOffset: CGFloat = 2.0
            let profilePic = UIImage(named: "profile_image_test")
            profileCell.ProfileImage.image = profilePic
            profileCell.ProfileImage.frame = CGRectMake(profileCell.ProfileImageCircle.frame.origin.x + imageToCircleOffset, profileCell.ProfileImageCircle.frame.origin.y + imageToCircleOffset, profileCell.ProfileImageCircle.frame.width - 2 * imageToCircleOffset, profileCell.ProfileImageCircle.frame.height - 2 * imageToCircleOffset)
            profileCell.ProfileImage.layer.cornerRadius = circleImageDiameter / 2.0
            
            
            
            profileCell.UserNameLabel.textColor = UIColor.whiteColor()
            profileCell.UserNameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.6)
            profileCell.UserNameLabel.text = currentUser.userName
            profileCell.UserNameLabel.center = CGPoint(x: (profileCell.ProfileLabel.center.x), y: (profileCell.ProfileLabel.center.y) + 2 * (profileCell.UserNameLabel.frame.height))
            
            
            profileCell.addSubview(profileCell.ProfileLabel)
            profileCell.addSubview(profileCell.ProfileImage)
            profileCell.addSubview(profileCell.ProfileImageCircle)
            
            
            
            
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: profileCell.frame.size.width, height: profileCell.frame.size.width))
            selectedView.backgroundColor = UIColor.eigenBlueColor()
            profileCell.selectedBackgroundView = selectedView
            
            return profileCell
            
        } else if indexPath.row == 1 || indexPath.row == 7 {
            let spacerCell: MenuCell = tableView.dequeueReusableCellWithIdentifier("spacerCell\(indexPath.row)", forIndexPath: indexPath) as! MenuCell
            spacerCell.backgroundColor = UIColor.eigenLightGrayColor()
            
            
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: spacerCell.frame.size.width, height: spacerCell.frame.size.width))
            selectedView.backgroundColor = UIColor.clearColor()
            spacerCell.selectedBackgroundView = selectedView
            
            return spacerCell
            
        } else if indexPath.row >= 2 && indexPath.row <= 7 {
            let menuCell: MenuCell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row - 1]) as! MenuCell
            menuCell.hidden = false
            
            let menuTextHeight = self.view.frame.height * 0.0274
            let menuTextY = menuTextHeight
            let extraTextSpace: CGFloat = 4.0
            let menuImageOffsetFromText: CGFloat = 1.0
            
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: menuCell.frame.size.width, height: menuCell.frame.size.height))
            menuCell.selectedBackgroundView = selectedView
            
            menuCell.MenuImage.frame = CGRectMake(self.view.frame.width * 0.05, menuTextY - menuImageOffsetFromText, menuTextHeight + menuImageOffsetFromText * 2.0, menuTextHeight + menuImageOffsetFromText * 2.0)
            
            let labelX = menuCell.MenuImage.frame.origin.x + menuCell.MenuImage.frame.width * 2.0
            menuCell.MenuLabel.frame = CGRectMake(labelX, menuTextY - extraTextSpace / 2.0, self.view.frame.width * 2.0 / 3.0, menuTextHeight + extraTextSpace)
            menuCell.MenuLabel.text = TableArray[indexPath.row - 1]
            
            if self.selectedScreenIndex == indexPath.row {
                menuCell.MenuImage.image = UIImage(named: BlueImagesArray[indexPath.row - 2])
                
                menuCell.MenuLabel.textColor = UIColor.eigenBlueColor()
                menuCell.MenuLabel.font = UIFont(name: "HelveticaNeue-Bold", size: menuTextHeight)
                
                menuCell.backgroundColor = UIColor.whiteColor()
                selectedView.backgroundColor = UIColor.clearColor()
                
            } else {
                menuCell.MenuImage.image = UIImage(named: ImagesArray[indexPath.row - 2])
                
                menuCell.MenuLabel.textColor = UIColor.eigenMidGrayTextColor()
                menuCell.MenuLabel.font = UIFont(name: "HelveticaNeue-Light", size: menuTextHeight)
                
                menuCell.backgroundColor = UIColor.eigenLightGrayColor()
                selectedView.backgroundColor = UIColor.eigenBlueColor()
            }
            
            menuCell.addSubview(menuCell.MenuImage)
            menuCell.addSubview(menuCell.MenuLabel)
            
            return menuCell
        } else if indexPath.row == 8 {
            let signOutCell: MenuCell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row - 2]) as! MenuCell
            
            let menuTextHeight = self.view.frame.height * 0.0274
            let menuTextY = menuTextHeight
            let extraTextSpace: CGFloat = 4.0
            let menuImageOffsetFromText: CGFloat = 1.0
            
            signOutCell.MenuImage.image = UIImage(named: ImagesArray[indexPath.row - 3])
            signOutCell.MenuImage.frame = CGRectMake(self.view.frame.width * 0.05, menuTextY - menuImageOffsetFromText, menuTextHeight + menuImageOffsetFromText * 2.0, menuTextHeight + menuImageOffsetFromText * 2.0)
            
            let labelX = signOutCell.MenuImage.frame.origin.x + signOutCell.MenuImage.frame.width * 2.0
            signOutCell.MenuLabel.frame = CGRectMake(labelX, menuTextY - extraTextSpace / 2.0, self.view.frame.width * 2.0 / 3.0, menuTextHeight + extraTextSpace)
            signOutCell.MenuLabel.textColor = UIColor.eigenMidGrayTextColor()
            signOutCell.MenuLabel.font = UIFont(name: "HelveticaNeue-Light", size: menuTextHeight)
            signOutCell.MenuLabel.text = "sign out"
            signOutCell.backgroundColor = UIColor.eigenLightGrayColor()
            
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: signOutCell.frame.size.width, height: signOutCell.frame.size.height))
            selectedView.backgroundColor = UIColor.clearColor()
            signOutCell.selectedBackgroundView = selectedView
            
            signOutCell.addSubview(signOutCell.MenuImage)
            signOutCell.addSubview(signOutCell.MenuLabel)
            
            return signOutCell
            
        } else {
            return UITableViewCell()
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return profileCellHeight
        } else if indexPath.row == 1 || indexPath.row == 8 {
            return self.view.frame.height / 13.5 * 1.5
        } else {
            return self.view.frame.height / 13.5
        }
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row >= 2 && indexPath.row <= 6 {
            selectedScreenIndex = indexPath.row
            
            for index in 2...6 {
                let indxPth = NSIndexPath(forRow: index, inSection: indexPath.section)
                self.tableView.reloadRowsAtIndexPaths([indxPth], withRowAnimation: UITableViewRowAnimation.None)
            }
            
            let segueIdentifiers: [String] = ["dashboardSegue", "profileSegue", "historySegue", "settingsSegue", "helpSegue"]
            
            self.performSegueWithIdentifier(segueIdentifiers[indexPath.row - 2], sender: nil)
            
        }
        
        
        if indexPath.row == 8 {
            /*
            let alertController = UIAlertController(title: "Sign out?", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
            alertController.addAction(UIAlertAction(title: "No way", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            */
            
            try! FIRAuth.auth()!.signOut()
            self.performSegueWithIdentifier("signOutSegue", sender: nil)
        }
    }
    
    
    func getNameForProfileCell() -> String {
        let usersName = currentUser.name
        var abrvdName: String = ""
        var namesArray: [String] = []
        var spaceIndex: [Int] = []
        
        let characterArray = Array(usersName.characters)
        for index in 0...characterArray.count - 1 {
            if characterArray[index] == " " {
                spaceIndex.append(index)
            }
        }
        
        if spaceIndex != [] {
            for index in 0...spaceIndex.count {
                
                var spcIndxIndex = 0
                if index == spaceIndex.count {
                    spcIndxIndex = index - 1
                } else {
                    spcIndxIndex = index
                }
                
                var subName: String = ""
                var subNameCharacterArray: [Character] = []
                
                var startingIndex = 0
                var finalIndex = spaceIndex[0]
                if index != 0 && index != spaceIndex.count{
                    startingIndex = spaceIndex[index - 1]
                    finalIndex = spaceIndex[spcIndxIndex]
                } else if index == spaceIndex.count {
                    startingIndex = spaceIndex[index - 1] + 1
                    finalIndex = characterArray.count - 1
                }
                for nextIndex in startingIndex...finalIndex{
                    subNameCharacterArray.append(characterArray[nextIndex])
                }
                subName = String(subNameCharacterArray)
                namesArray.append(subName)
            }
        }
        
        if namesArray.count > 1 {
            var lastNameCharacters = Array(namesArray[namesArray.count - 1].characters)
            let lastNameFirstLetter: String = String(lastNameCharacters[0])
            abrvdName = "\(namesArray[0]) \(lastNameFirstLetter)."
        }
        return abrvdName
    }
    
}



















