//
//  GlobalFuncations.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-05-03.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import MapKit
import UIKit

extension UIImage {
    class func scaleImageToScale(img: UIImage, scale: Double) -> UIImage {
        let originalSize = img.size
        
        let size: CGSize = CGSize(width: originalSize.width * CGFloat(scale), height: originalSize.height * CGFloat(scale))
        
        UIGraphicsBeginImageContext(size)
        
        img.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    class func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        img.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return scaledImage
    }
}

func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.drawInRect(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

let currentUser = Driver(UsrNm: "connor_chuk", PsWrd: "hello", Nm: "connor holowachuk", CrCmnpy: "acura", CrMdl: "TSX", CrYr: 2001, StrtAdrss: "706 randolph ave.", Cty: "windsor", Prvnc: "on", PstlCd: "n9b 2t8", Cntry: "canada")

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

func calc3DMagnitude(x: Double, y: Double, z: Double) -> Double {
    let preSqrtSoS = x * x + y * y + z * z
    let magnitude = sqrt(preSqrtSoS)
    return magnitude
}