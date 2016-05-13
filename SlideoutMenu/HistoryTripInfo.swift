//
//  HistoryInfoData.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-09.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HistoryTripInfo: UIViewController, PassDataDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    var passedIndex: Int = 0
    
    override func viewDidLoad() {
        
        print("---- in history trip info view controller ----")
        
        super.viewDidLoad()
        
        self.headerLabel.text = String(currentUser.tripLog[passedIndex].startTimeStamp.hour)
    }
    
    func userToPassData(passingIndex: Int) {
        passedIndex = passingIndex
    }
}