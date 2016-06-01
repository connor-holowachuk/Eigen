//
//  PopUp.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-30.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AnimatableView: UIView {
    func animate(){
        print("Should overide by subclasss", terminator: "")
    }
}

public class PopUp: UIViewController, UITextFieldDelegate {
    
    let darkTextColor = UIColor(hex: 0x3B3B3B)
    
    var animatedView: AnimatableView?
    
    var dismissButton = UIButton()
    var dismissButtonLabel = UILabel()
    var dismissButtonText = "Go back"
    
    var cancelButton = UIButton()
    var cancelLabel = UILabel()
    let cancelLabelText = "cancel"
    
    var contentView = UIView()
    var dismissButtonView = UIView()
    var strongSelf: PopUp?
    
    var headerLabel = UILabel()
    var subTitleLabel1 = UILabel()
    var subTitleLabel2 = UILabel()
    
    var overlay = UIVisualEffectView()
    
    let errorTitleHeadings: [String] = ["No email entered.", "No password entered.", "Email doesn't exist.", "Invalid email.", "Incorrect email.", "Incorrect email.", "Network error."]
    let errorDescriptions1: [String] = ["It looks like you didn't enter", "It looks like you didn't type", "The email you entered doesn't exist", "You entered an invalid", "It appears you've changed", "The password you entered isn't the", "There's a problem with your"]
    let errorDescriptions2: [String] = ["an email.", "in a password.", "in our system. Feel free to sign up!", "email.", "your password on another device.", "correct password for the email.", "network."]
    
    //subViews only used in sign up form
    var nameLineImage = UIImageView()
    var emailLineImage = UIImageView()
    var addressLineImage = UIImageView()
    var addressLine2Image = UIImageView()
    var passwordLineImage = UIImageView()
    var confirmPasswordLineImage = UIImageView()
    
    let lineImageNameArray: [String] = ["name_line_image", "email_line_image", "address_line_image", "address_line_2_image", "password_line_image", "confirm_password_line_image"]
    let linePlaceholderTextArray: [String] = ["name", "email", "address", "city", "PC", "password", "confirm password"]
    
    var nameField = UITextField()
    var emailField = UITextField()
    var addressField = UITextField()
    var cityField = UITextField()
    var PCField = UITextField()
    var passwordField = UITextField()
    var confirmPasswordField = UITextField()
    
    var name: String?
    var email: String?
    var address: String?
    var city: String?
    var PC: String?
    var password: String?
    var confirmPassword: String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(contentView)
        
        //Retaining itself strongly so can exist without strong refrence
        strongSelf = self
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("yo")
        self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignIn.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignIn.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func setupContentView(errorMessage: Int, buttonColor: UIColor) {
        
        overlay.contentView.alpha = 1.0
        overlay.frame = view.frame
        view.addSubview(self.overlay)
        
        let popUpHeight = self.view.frame.height / 3.0
        let popUpWidth = self.view.frame.width * 5.0 / 6.0
        
        let buttonHeight = popUpHeight / 6.0
        let buttonWidth = popUpWidth / 2.0
        
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 13.0
        contentView.layer.masksToBounds = true
        contentView.frame = CGRectMake((self.view.frame.width - popUpWidth) / 2.0, (self.view.frame.height - popUpHeight) / 2.0, popUpWidth, popUpHeight)
        contentView.backgroundColor = UIColor.whiteColor()
        view.addSubview(contentView)
        
        let buttonX = contentView.frame.origin.x + popUpWidth / 4.0
        let buttonY = contentView.frame.origin.y + popUpHeight * 0.9 - buttonHeight
        
        dismissButtonView.backgroundColor = buttonColor
        dismissButtonView.layer.cornerRadius = 13.0
        dismissButtonView.layer.masksToBounds = true
        dismissButtonView.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)
        //contentView.addSubview(dismissButtonView)
        view.addSubview(dismissButtonView)
        
        let signInButtonTextHeight: CGFloat = buttonHeight / 1.8
        dismissButtonLabel.text = dismissButtonText
        dismissButtonLabel.textColor = UIColor.whiteColor()
        dismissButtonLabel.textAlignment = NSTextAlignment.Center
        dismissButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: signInButtonTextHeight)
        dismissButtonLabel.frame = dismissButtonView.frame
        //contentView.addSubview(dismissButtonLabel)
        view.addSubview(dismissButtonLabel)
        
        dismissButton.frame = dismissButtonView.frame
        dismissButton.addTarget(self, action: #selector(PopUp.dismissPopUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //contentView.addSubview(dismissButton)
        view.addSubview(dismissButton)
        
        let headerFontSize = popUpHeight * 0.1124436938
        let textWidth = contentView.frame.width * 0.872
        let textX = contentView.frame.origin.x + contentView.frame.width * 0.064
        headerLabel.text = errorTitleHeadings[errorMessage]
        headerLabel.textColor = darkTextColor
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: headerFontSize)
        headerLabel.frame = CGRectMake(textX, contentView.frame.origin.y + contentView.frame.height * 0.1248023988, textWidth, headerFontSize * 2)
        //contentView.addSubview(headerLabel)
        view.addSubview(headerLabel)
        
        let subTitleFontSize = contentView.frame.height * 0.065
        let subTitleHeight = subTitleFontSize + 4.0
        subTitleLabel1.text = errorDescriptions1[errorMessage]
        subTitleLabel1.textColor = darkTextColor
        subTitleLabel1.textAlignment = NSTextAlignment.Center
        subTitleLabel1.font = UIFont(name: "AvenirNext-Regular", size: subTitleFontSize)
        subTitleLabel1.frame = CGRectMake(textX, contentView.frame.origin.y + contentView.frame.height / 2.0 - 4.0 - subTitleHeight, textWidth, subTitleHeight)
        //contentView.addSubview(subTitleLabel1)
        view.addSubview(subTitleLabel1)
        
        subTitleLabel2.text = errorDescriptions2[errorMessage]
        subTitleLabel2.textColor = darkTextColor
        subTitleLabel2.textAlignment = NSTextAlignment.Center
        subTitleLabel2.font = UIFont(name: "AvenirNext-Regular", size: subTitleFontSize)
        subTitleLabel2.frame = CGRectMake(textX, contentView.frame.origin.y + contentView.frame.height / 2.0 + 4.0, textWidth, subTitleHeight)
        //contentView.addSubview(subTitleLabel2)
        view.addSubview(subTitleLabel2)
        
        
    }
    
    
    private func setupSignUpView(buttonColor: UIColor) {
        
        overlay.contentView.alpha = 1.0
        overlay.frame = view.frame
        view.addSubview(self.overlay)
        
        let popUpHeight = self.view.frame.height * 5.0 / 6.0
        let popUpWidth = self.view.frame.width * 5.0 / 6.0
        
        let buttonHeight = self.view.frame.height / 18.0
        let buttonWidth = popUpWidth / 2.0
        
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 13.0
        contentView.layer.masksToBounds = true
        contentView.frame = CGRectMake((self.view.frame.width - popUpWidth) / 2.0, (self.view.frame.height - popUpHeight) / 2.0, popUpWidth, popUpHeight)
        contentView.backgroundColor = UIColor.whiteColor()
        view.addSubview(contentView)
        
        let buttonX = contentView.frame.origin.x + popUpWidth / 4.0
        let buttonY = contentView.frame.origin.y + contentView.frame.height - (self.view.frame.height * 0.056) - buttonHeight
            
            //contentView.frame.origin.y + popUpHeight - self.view.frame.height * 0.033333 - buttonHeight
        
        dismissButtonView.backgroundColor = buttonColor
        dismissButtonView.layer.cornerRadius = 13.0
        dismissButtonView.layer.masksToBounds = true
        dismissButtonView.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)
         view.addSubview(dismissButtonView)
        
        let signInButtonTextHeight: CGFloat = buttonHeight / 1.8
        dismissButtonLabel.text = "Sign up"
        dismissButtonLabel.textColor = UIColor.whiteColor()
        dismissButtonLabel.textAlignment = NSTextAlignment.Center
        dismissButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: signInButtonTextHeight)
        dismissButtonLabel.frame = dismissButtonView.frame
        view.addSubview(dismissButtonLabel)
        
        dismissButton.frame = dismissButtonView.frame
        dismissButton.addTarget(self, action: #selector(PopUp.attemptLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(dismissButton)
        
        let headerFontSize = self.view.frame.height * 0.03748123127
        let textWidth = contentView.frame.width * 0.872
        let textX = contentView.frame.origin.x + contentView.frame.width * 0.064
        headerLabel.text = "Go ahead, sign up."
        headerLabel.textColor = darkTextColor
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: headerFontSize)
        headerLabel.frame = CGRectMake(textX, contentView.frame.origin.y + self.view.frame.height * 0.0416007996, textWidth, headerFontSize * 2)
        view.addSubview(headerLabel)
        
        let subTitleFontSize = self.view.frame.height * 0.0228
        let subTitleHeight = subTitleFontSize + 4.0
        let subTitle1Y = self.headerLabel.frame.origin.y + self.headerLabel.frame.height + (subTitleHeight * 0.666667)
        subTitleLabel1.text = "Quickly fill out the information below"
        subTitleLabel1.textColor = darkTextColor
        subTitleLabel1.textAlignment = NSTextAlignment.Center
        subTitleLabel1.font = UIFont(name: "AvenirNext-Regular", size: subTitleFontSize)
        subTitleLabel1.frame = CGRectMake(textX, subTitle1Y, textWidth, subTitleHeight)
        //contentView.addSubview(subTitleLabel1)
        view.addSubview(subTitleLabel1)
        
        subTitleLabel2.text = "to get started driving."
        subTitleLabel2.textColor = darkTextColor
        subTitleLabel2.textAlignment = NSTextAlignment.Center
        subTitleLabel2.font = UIFont(name: "AvenirNext-Regular", size: subTitleFontSize)
        subTitleLabel2.frame = CGRectMake(textX, subTitle1Y + 4.0 + subTitleHeight, textWidth, subTitleHeight)
        view.addSubview(subTitleLabel2)
        
        
        let cancelY = buttonY + buttonHeight + (subTitleHeight * 0.33333)
        cancelLabel.text = cancelLabelText
        cancelLabel.textColor = darkTextColor
        cancelLabel.textAlignment = NSTextAlignment.Center
        cancelLabel.font = UIFont(name: "AvenirNext-Regular", size: subTitleFontSize)
        cancelLabel.frame = CGRectMake(textX, cancelY, textWidth, subTitleHeight)
        view.addSubview(cancelLabel)
        
        cancelButton.frame = cancelLabel.frame
        cancelButton.addTarget(self, action: #selector(PopUp.dismissPopUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(cancelButton)
        
        let lineImageArray: [UIImageView] = [self.nameLineImage, self.emailLineImage, self.addressLineImage, self.addressLine2Image, self.passwordLineImage, self.confirmPasswordLineImage]
        let textFieldArray: [UITextField] = [self.nameField, self.emailField, self.addressField, self.cityField, self.PCField, self.passwordField, self.confirmPasswordField]
        
        let imageWidth = contentView.frame.width * 0.8
        let imageX = contentView.frame.origin.x + contentView.frame.width * 0.1
        let imageHeight = imageWidth * 0.1071428571
        let fieldY = subTitleLabel2.frame.origin.y + 2.3333 * subTitleHeight
        let imageSpacingY = ((dismissButton.frame.origin.y - fieldY) - imageHeight * 6.0) / 6.0
        
        let textFieldX = imageX + imageWidth * 0.1031746032
        let textFieldWidth = imageWidth - (textFieldX - imageX)
        let textFieldOffset: CGFloat = 4.0
        
        for index in 0...textFieldArray.count - 1{
            var indexSpecial = index
            
            if index >= 4 {
                indexSpecial = index - 1
            }
            
            let imageY = fieldY + (CGFloat(indexSpecial) * (imageSpacingY + imageHeight))
            
            lineImageArray[indexSpecial].image = UIImage(named: lineImageNameArray[indexSpecial])
            lineImageArray[indexSpecial].frame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
            view.addSubview(lineImageArray[indexSpecial])
            
            let textFieldY = lineImageArray[indexSpecial].frame.origin.y + lineImageArray[indexSpecial].frame.height - textFieldOffset - subTitleHeight
            
            textFieldArray[index].delegate = self
            textFieldArray[index].font = UIFont(name: "AvenirNext-Regular", size: subTitleFontSize)
            
            textFieldArray[index].attributedPlaceholder = NSAttributedString(string: linePlaceholderTextArray[index], attributes: [NSForegroundColorAttributeName: darkTextColor.colorWithAlphaComponent(0.9)])
            textFieldArray[index].textColor = darkTextColor
            
            if index == 0 || index == 2 || index == 3 || index == 4 {
                textFieldArray[index].autocorrectionType = UITextAutocorrectionType.No
                textFieldArray[index].autocapitalizationType = UITextAutocapitalizationType.Words
                textFieldArray[index].keyboardType = UIKeyboardType.Default
            } else if index == 1 {
                textFieldArray[index].autocorrectionType = UITextAutocorrectionType.No
                textFieldArray[index].autocapitalizationType = UITextAutocapitalizationType.None
                textFieldArray[index].keyboardType = UIKeyboardType.EmailAddress
            } else {
                textFieldArray[index].autocorrectionType = UITextAutocorrectionType.No
                textFieldArray[index].autocapitalizationType = UITextAutocapitalizationType.None
                textFieldArray[index].keyboardType = UIKeyboardType.Default
                textFieldArray[index].secureTextEntry = true
            }
            
            if index != 4 && index != 3 {
                textFieldArray[index].frame = CGRectMake(textFieldX, textFieldY, textFieldWidth, subTitleHeight)
            } else if index == 3{
                textFieldArray[index].frame = CGRectMake(textFieldX, textFieldY, textFieldWidth * 0.628, subTitleHeight)
                
            } else {
                let fieldAt4XSpacing = 0.058 * textFieldWidth
                let fieldAt4X = textFieldArray[3].frame.origin.x + textFieldArray[3].frame.width + fieldAt4XSpacing
                textFieldArray[index].frame = CGRectMake(fieldAt4X, textFieldY, textFieldWidth * 0.314, subTitleHeight)
            }
            
            view.addSubview(textFieldArray[index])
            
        }
    }
    
    @objc private func attemptLogin(sender: UIButton) {
        let textFieldArray: [UITextField] = [self.nameField, self.emailField, self.addressField, self.cityField, self.PCField, self.passwordField, self.confirmPasswordField]
        
        for index in 0...textFieldArray.count - 1 {
            if textFieldArray[index].text == "" {
                UIView.animateWithDuration(1.2) {
                    textFieldArray[index].attributedPlaceholder = NSAttributedString(string: self.linePlaceholderTextArray[index], attributes: [NSForegroundColorAttributeName: UIColor.redColor().colorWithAlphaComponent(0.9)])
                }
            }
        }
    }
    
    func animateAlert() {
        
        view.alpha = 0;
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.alpha = 1.0;
        })
        
        let previousTransform = self.view.transform
        self.view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.layer.transform = CATransform3DMakeScale(1.1, 1.1, 0.0);
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0);
                    if self.animatedView != nil {
                        self.animatedView!.animate()
                    }
                    
                }) { (Bool) -> Void in
                    
                    self.view.transform = previousTransform
                }
            }
        }
    }
    
    public func showAlert(errorMessage: Int?, buttonColor: UIColor) -> PopUp {
        var other = true
        if errorMessage == nil {
            other = false
        }
        
        self.showAlert(errorMessage, buttonColor: buttonColor, other: other)
        return self
    }
    
    public func showAlert(errorMessage: Int?, buttonColor: UIColor, other: Bool) {
        //userAction = action
        let window: UIWindow = UIApplication.sharedApplication().keyWindow!
        window.addSubview(view)
        window.bringSubviewToFront(view)
        view.frame = window.bounds
        if other == true {
            self.setupContentView(errorMessage!, buttonColor: buttonColor)
        } else {
            self.setupSignUpView(buttonColor)
        }
        self.animateAlert()
        UIView.animateWithDuration(1.2) {
            self.overlay.effect = UIBlurEffect(style: .Dark)
        }
    }
    
    @objc private func dismissPopUp(sender: UIButton) {
        UIView.animateWithDuration(0.369, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.alpha = 0.0
        }) { (Bool) -> Void in
            self.view.removeFromSuperview()
            self.clearAlertView()
            self.strongSelf = nil
        }
    }
    
    private func clearAlertView () {
        self.view.removeFromSuperview()
        self.dismissButton.removeFromSuperview()
        self.dismissButtonLabel.removeFromSuperview()
        self.contentView.removeFromSuperview()
        self.dismissButtonView.removeFromSuperview()
        self.overlay.removeFromSuperview()
        self.headerLabel.removeFromSuperview()
        self.subTitleLabel1.removeFromSuperview()
        self.subTitleLabel2.removeFromSuperview()
        
        self.contentView = UIView()
        self.dismissButtonView = UIView()
        self.dismissButton = UIButton()
        self.dismissButtonLabel = UILabel()
        self.overlay = UIVisualEffectView()
        self.headerLabel = UILabel()
        self.subTitleLabel1 = UILabel()
        self.subTitleLabel2 = UILabel()
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let textFieldArray: [UITextField] = [self.nameField, self.emailField, self.addressField, self.cityField, self.PCField, self.passwordField, self.confirmPasswordField]
            var selectedIndex: Int = 0
            
            for index in 0...textFieldArray.count - 1 {
                if textFieldArray[index].editing == true {
                    if index == 4 {
                        selectedIndex = 3
                    } else {
                        selectedIndex = index
                    }
                }
            }
            
            self.view.frame.origin.y = 0.0 - (keyboardSize.height / 7.21) * CGFloat(selectedIndex)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            self.view.frame.origin.y = 0.0
        }
    }
    
}
