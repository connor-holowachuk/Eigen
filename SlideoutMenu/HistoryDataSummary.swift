//
//  HistoryDataSummary.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-09.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HistoryDataSummary: UIViewController, PassDataDelegate {
    
    var passedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func userToPassData(passingIndex: Int) {
        passedIndex = passingIndex
    }
}