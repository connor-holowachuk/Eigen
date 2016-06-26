//
//  GlobalFunctions.swift
//  SlideoutMenu
//
//  Created by Connor Holowachuk on 2016-05-03.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import QuartzCore

struct defaultKeys {
    static let keyOne = "firstStringKey"
    static let keyTwo = "secondStringKey"
}

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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    class func eigenBlueColor() -> UIColor { return UIColor(hex: 0x5EA8FB) }
    class func eigenLightGrayColor() -> UIColor { return UIColor(hex: 0xF3F3F3) }
    class func eigenMidGrayTextColor() -> UIColor { return UIColor(hex: 0x6B707B) }
    class func eigenDarkGrayTextColor() -> UIColor { return UIColor(hex: 0x3B3B3B) }
    class func eigenPurpleColor() -> UIColor { return UIColor(hex: 0xC46BEF) }
    class func eigenTurquoiseColor() -> UIColor { return UIColor(hex: 0x4DF4C6) }
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

struct currentDriver {
    
}

let currentUser = Driver(UsrNm: "connor_chuk", PsWrd: "hello", Nm: "Connor Holowachuk", CrCmnpy: "Acura", CrMdl: "TSX", CrYr: 2001, StrtAdrss: "706 Randolph Ave.", Cty: "Windsor", Prvnc: "ON", PstlCd: "N9B 2T8", Cntry: "Canada")

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

func pickRandomColour() -> UIColor {
    let colourArray: [UIColor] = [UIColor.eigenPurpleColor(), UIColor.eigenBlueColor(), UIColor.eigenTurquoiseColor()]
    let randomInt = arc4random_uniform(UInt32(colourArray.count))
    return colourArray[Int(randomInt)]
}

func statusBarHeight() -> CGFloat {
    let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
    return Swift.min(statusBarSize.width, statusBarSize.height)
}

extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
