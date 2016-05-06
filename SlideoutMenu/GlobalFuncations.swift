//
//  GlobalFuncations.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-05-03.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import MapKit


let currentUser = Driver(UsrNm: "connor_chuk", PsWrd: "hello", Nm: "Connor Holowachuk", CrCmnpy: "Acura", CrMdl: "TSX", CrYr: 2001, Adrss: "706 Randolph Ave.", Cty: "Windsor")

//Global functions

func calcDistance(locationA: CLLocationCoordinate2D, locationB: CLLocationCoordinate2D) -> double_t {
    
    
    let phi1 = toRad(Double(locationA.latitude))
    let phi2 = toRad(Double(locationB.latitude))
    let deltaPhi = toRad(Double(locationA.latitude - locationB.latitude))
    let deltaLambda = toRad(Double(locationA.longitude - locationB.longitude))
    
    let a = sin(deltaPhi / 2.0) * sin(deltaPhi / 2.0) + cos(phi1) * cos(phi2) * sin(deltaLambda / 2.0) * sin(deltaLambda / 2.0)
    
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    
    let distance = 6_371_000 * c
    
    return distance
}

func toRad(angle: Double) -> Double {
    return angle * 3.141592654 / 180.0
}

func roundDouble(number: Double, decimalPlaces: Int) -> Double {
    let shifter = pow(10.0, Double(decimalPlaces))
    let newNumber = number * shifter
    let intOfNewNumber = Int(newNumber)
    let finalNumber = Double(intOfNewNumber) / shifter
    return finalNumber
}