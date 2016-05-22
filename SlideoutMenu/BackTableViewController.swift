//
//  BackTableViewController.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-28.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation

class BackTableViewController: UITableViewController {
    
    var TableArray = [String]()
    var ImagesArray = [String]()
    
    override func viewDidLoad() {
        
        print("---- back table view controller loaded ----")
        
        super.viewDidLoad()
        TableArray = ["c holowachuk", "dashboard", "profile", "history", "settings", "help", "signOut"]
        ImagesArray = ["dashboardIcon", "profileIcon", "historyIcon", "settingsIcon", "helpIcon", "signOutIcon"]
        //self.tableView.registerClass(ProfileCell.self, forCellReuseIdentifier: TableArray[0])
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor(hex: 0x262531)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.scrollEnabled = false
        return TableArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                
        if indexPath.row == 0 {
            let profileCell = tableView.dequeueReusableCellWithIdentifier("c holowachuk", forIndexPath: indexPath) as! ProfileCell
            profileCell.backgroundColor = UIColor.clearColor()
            let profilePic = UIImage(named: "profile_pic_test")
            profileCell.ProfileImage?.image = profilePic
            profileCell.ProfileLabel?.textColor = UIColor.lightTextColor()
            profileCell.ProfileLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
            profileCell.ProfileLabel?.text = currentUser.name
            profileCell.ProfileLabel?.center = CGPoint(x: self.view.frame.width * 0.34765 + (profileCell.ProfileLabel.frame.width / 2), y: self.view.frame.height * 0.3476521739)// - profileCell.ProfileLabel.frame.height)
            profileCell.UserNameLabel?.textColor = UIColor.lightTextColor().colorWithAlphaComponent(0.4)
            profileCell.UserNameLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16.6)
            profileCell.UserNameLabel?.text = currentUser.userName
            profileCell.UserNameLabel.center = CGPoint(x: (profileCell.ProfileLabel?.center.x)!, y: (profileCell.ProfileLabel?.center.y)! + 2 * (profileCell.UserNameLabel?.frame.height)!)
            
            //profileCell.indentationWidth = self.view.bounds.width * 0.1415333333
            
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: profileCell.frame.size.width, height: profileCell.frame.size.width))
            selectedView.backgroundColor = UIColor(hex: 0x262531)
            profileCell.selectedBackgroundView = selectedView
            
            return profileCell
        } else if indexPath.row == 6{
            let signOutCell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as! MenuCell
            signOutCell.MenuImage?.image = UIImage(named: ImagesArray[indexPath.row - 1])
            signOutCell.MenuLabel?.textColor = UIColor.lightTextColor().colorWithAlphaComponent(0.6)
            signOutCell.MenuLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
            signOutCell.MenuLabel?.text = "sign out"
            signOutCell.backgroundColor = UIColor.clearColor()
            
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: signOutCell.frame.size.width, height: signOutCell.frame.size.width))
            selectedView.backgroundColor = UIColor.clearColor()
            signOutCell.selectedBackgroundView = selectedView
            
            return signOutCell
        } else {
            let menuCell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as! MenuCell
            menuCell.MenuImage?.image = UIImage(named: ImagesArray[indexPath.row - 1])
            menuCell.MenuLabel?.textColor = UIColor.lightTextColor()
            menuCell.MenuLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
            menuCell.MenuLabel?.text = TableArray[indexPath.row]
            menuCell.backgroundColor = UIColor.clearColor()
           // menuCell.textLabel?.text = TableArray[indexPath.row]
            
            
            
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: menuCell.frame.size.width, height: menuCell.frame.size.width))
            selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
            menuCell.selectedBackgroundView = selectedView
            
            //menuCell.selectedBackgroundView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)

            return menuCell
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height * 0.3476521739 - 18.0
        } else if indexPath.row == 6{
            return self.view.frame.height - 4 * self.view.frame.height * 0.08202698651 - self.view.frame.height * 0.3476521739 - 18.0
        } else {
            return self.view.frame.height * 0.08202698651
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 6 {
            
            let alertController = UIAlertController(title: "Sign out?", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
            alertController.addAction(UIAlertAction(title: "No way", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    

 /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.width))
        selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        cell.selectedBackgroundView = selectedView
        
        for index in 0...(TableArray.count - 1) {
            let otherCells = tableView.dequeueReusableCellWithIdentifier(TableArray[index])
            
            otherCells!.backgroundColor = UIColor.darkGrayColor()
            otherCells!.textLabel?.text = TableArray[index]
            otherCells!.textLabel?.textColor = UIColor.lightTextColor()
        }
        
        
    }*/
    
}