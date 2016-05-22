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
    
    var streetAdress: String!
    var city: String!
    var province: String!
    var postalCode: String!
    var country: String!
    
    //settings
    var preferedMapType: MKMapType = MKMapType.Standard
    
    //financial
    var advertisers: [Advertiser]!
    
    //history
    var tripLog: [TripInfoForMem] = []
    
    
    init(UsrNm: String, PsWrd: String, Nm: String, CrCmnpy: String, CrMdl: String, CrYr: Int, StrtAdrss: String, Cty: String, Prvnc: String, PstlCd: String, Cntry: String) {
        userName = UsrNm
        password = PsWrd
        name = Nm
        carCompany = CrCmnpy
        carModel = CrMdl
        carYear = CrYr
        streetAdress = StrtAdrss
        city = Cty
        province = Prvnc
        postalCode = PstlCd
        country = Cntry
    }
}