//
//  Driver.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-05-03.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Driver {
    //personal
    var userName: String!
    var password: String!
    
    var name: String!
    var carCompany: String!
    var carModel: String!
    var carYear: Int!
    
    var adress: String!
    var city: String!
    
    //settings
    var preferedMapType: MKMapType = MKMapType.Standard
    
    //financial
    var advertisers: [Advertiser]!
    
    //history
    var tripLog: [TripInfo] = []
    
    
    init(UsrNm: String, PsWrd: String, Nm: String, CrCmnpy: String, CrMdl: String, CrYr: Int, Adrss: String, Cty: String) {
        userName = UsrNm
        password = PsWrd
        name = Nm
        carCompany = CrCmnpy
        carModel = CrMdl
        carYear = CrYr
        adress = Adrss
        city = Cty
    }
}