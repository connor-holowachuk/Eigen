//
//  Advertiser.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-04-30.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import MapKit

class Advertiser {
    var name: String!
    var descirption: String!
    var locations: [CLLocationCoordinate2D]!
    var criticalRadius: Double = 1_200
    var phoneNumer: Int?
    var logo: UIImage?
}