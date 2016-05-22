//
//  HistoryViewControllerForPages.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-13.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

class HistoryViewControllerForPages: UIViewController, UIPageViewControllerDataSource, UIScrollViewDelegate {

    var pageViewController = UIPageViewController()
    
    var backgroundImage = UIImageView()
    var backButtonIconImage = UIImageView()
    var backButtonIconOverlay = UIButton()
    let pageController = UIPageControl()
    var headerLabel = UIImageView()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TripInfoViewController"),
                UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TripDataViewController")]
    }()
    
    func backButtonPressed(sender: UIButton) {
        print("here")
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 3.0 + (self.view.frame.height * 0.02273863068))
        self.backgroundImage.image = UIImage(named: "white_header_background_with_shade")
        self.view.addSubview(backgroundImage)
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        if let firstViewController = self.orderedViewControllers.first {
            self.pageViewController.setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
        }
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        let headerLabelHeight: CGFloat = self.view.frame.height / 12.3334
        let headerLabelWidth: CGFloat = headerLabelHeight * 4.05
        let iconSize: CGFloat = self.view.frame.height * 0.02464467766
        
        let slideMenuIconY = (self.view.frame.height / 12.0 - 20) + headerLabelHeight / 2.0 - iconSize / 2.0
        self.backButtonIconImage.frame = CGRectMake(self.view.frame.width * 0.055556, slideMenuIconY, iconSize, iconSize)
        self.backButtonIconImage.image = UIImage(named: "close_window_icon")
        self.view.addSubview(backButtonIconImage)
        
        self.headerLabel.frame = CGRectMake((self.view.frame.width / 2.0) - (headerLabelWidth / 2.0), self.view.frame.height / 12.0 - 20, headerLabelWidth, headerLabelHeight)
        self.headerLabel.image = UIImage(named: "trip_summary_title_header")
        self.view.addSubview(headerLabel)
        
        let extraButtonSpace: CGFloat = 10.0
        self.backButtonIconOverlay.frame = CGRectMake(self.backButtonIconImage.frame.origin.x - extraButtonSpace, self.backButtonIconImage.frame.origin.y - extraButtonSpace, self.backButtonIconImage.frame.width + extraButtonSpace * 2.0, self.backButtonIconImage.frame.height + extraButtonSpace * 2.0)
        self.backButtonIconOverlay.addTarget(self, action: #selector(HistoryViewControllerForPages.backButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButtonIconOverlay)
        
        self.pageController.numberOfPages = 2
        self.pageController.currentPage = 0
        self.pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        self.pageController.currentPageIndicatorTintColor = UIColor.cyanColor()
        self.pageController.backgroundColor = UIColor.clearColor()
        self.pageController.frame = CGRect(x: (self.view.frame.width / 2.0) - 20, y: self.backgroundImage.bounds.height - 50, width: 40, height: 37)
        self.view.addSubview(self.pageController)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.delegate = self
        print("here")
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
