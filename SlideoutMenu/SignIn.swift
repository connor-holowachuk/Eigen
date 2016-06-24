//
//  SignIn.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-29.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class SignIn: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate{
    
    var backgroundColour = UIColor(hex: 0x5EA8FB)
    
    var header1 = UILabel()
    var header2 = UILabel()
    var header3 = UILabel()
    
    var signInButtonImage = UIImageView()
    var signInLabel = UILabel()
    var signInButton = UIButton()
    
    var signUpLabel1 = UILabel()
    var signUpLabel2 = UILabel()
    var signUpButtonOverlay = UIButton()
    
    var emailBarImage = UIImageView()
    var passwordBarImage = UIImageView()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    
    var enteredEmail: String!
    var enteredPassword: String!
    
    let overlay = UIVisualEffectView()
    
    var errorMessage: Int = 0
    
    var inPopUpView: Bool = false
    var keyBoardHideDisabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignIn.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignIn.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //backgroundColour = pickRandomColour()
        self.view.backgroundColor = backgroundColour
        
        //setup header text
        let fontSize = self.view.frame.height * 0.13 //0.0652173913
        let headerFont = UIFont(name: "AvenirNext-Bold", size: fontSize)
        let headerTextXOffset: CGFloat = 5.0
        let spacingBetweenText = self.view.frame.height * -0.04
        
        self.header1.text = "Welcome"
        self.header1.font = headerFont
        self.header1.textColor = UIColor.whiteColor()
        self.header1.textAlignment = NSTextAlignment.Left
        self.header1.adjustsFontSizeToFitWidth = true
        self.header1.frame = CGRectMake(self.view.frame.width / 6.0 - headerTextXOffset, self.view.frame.height / 6.0 - 33.6, self.view.frame.width * 2.0 / 3.0 + (2 * headerTextXOffset), fontSize + 4.0)
        self.view.addSubview(self.header1)
        
        self.header2.text = "back to"
        self.header2.font = headerFont
        self.header2.textColor = UIColor.whiteColor()
        self.header2.textAlignment = NSTextAlignment.Left
        self.header2.adjustsFontSizeToFitWidth = true
        let header2Y = self.header1.frame.origin.y + self.header1.frame.height + spacingBetweenText
        self.header2.frame = CGRectMake(self.view.frame.width / 6.0 - headerTextXOffset, header2Y, self.view.frame.width * 0.5651866667 + (2 * headerTextXOffset), fontSize + 4.0)
        self.view.addSubview(self.header2)
        
        self.header3.text = "Eigen."
        self.header3.font = headerFont
        self.header3.textColor = UIColor.whiteColor()
        self.header3.adjustsFontSizeToFitWidth = true
        self.header3.textAlignment = NSTextAlignment.Left
        let header3Y = self.header2.frame.origin.y + self.header2.frame.height + spacingBetweenText
        self.header3.frame = CGRectMake(self.view.frame.width / 6.0 - headerTextXOffset, header3Y, self.view.frame.width * 0.4602266667 + (2 * headerTextXOffset), fontSize + 4.0)
        self.view.addSubview(self.header3)
        
        //setup bottom images, buttons and textfield
        let signInButtonWidth = self.view.frame.width / 2.0
        let signInButtonHeight = signInButtonWidth * 0.2421052632
        let signInButtonY = self.view.frame.height * 5.0 / 6.0 - signInButtonHeight
        self.signInButtonImage.frame = CGRectMake(self.view.frame.width / 4.0, signInButtonY, self.view.frame.width / 2.0, signInButtonHeight)
        self.signInButtonImage.image = UIImage(named: "sign_in_button")
        self.view.addSubview(self.signInButtonImage)
        
        let signInButtonTextHeight: CGFloat = signInButtonHeight / 2.0
        self.signInLabel.text = "Sign in"
        self.signInLabel.textColor = backgroundColour
        self.signInLabel.textAlignment = NSTextAlignment.Center
        self.signInLabel.font = UIFont(name: "AvenirNext-Regular", size: signInButtonTextHeight)
        self.signInLabel.frame = self.signInButtonImage.frame
        self.view.addSubview(self.signInLabel)
        
        self.signInButton.frame = self.signInButtonImage.frame
        self.signInButton.addTarget(self, action: #selector(SignIn.signInButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.signInButton)
        
        let loginBarHeight = self.view.frame.height * 0.03745877061
        let loginBarSpacing = self.view.frame.height / 12.0
        
        self.passwordBarImage.image = UIImage(named: "password_login_bar")
        self.passwordBarImage.frame = CGRectMake(self.view.frame.width / 6.0, self.signInButtonImage.frame.origin.y - self.view.frame.height / 12.0 - loginBarHeight, self.view.frame.width * 2.0 / 3.0, loginBarHeight)
        self.view.addSubview(self.passwordBarImage)
        
        self.emailBarImage.image = UIImage(named: "email_login_bar")
        self.emailBarImage.frame = CGRectMake(self.view.frame.width / 6.0, self.passwordBarImage.frame.origin.y - loginBarSpacing, self.view.frame.width * 2.0 / 3.0, loginBarHeight)
        self.view.addSubview(self.emailBarImage)
        
        let textFieldOffsetY: CGFloat = 6.0
        let textFieldOffsetX: CGFloat = self.view.frame.width * 0.04376266667 + 2 * textFieldOffsetY
        
        self.passwordTextField.delegate = self
        self.passwordTextField.font = UIFont(name: "AvenirNext-Regular", size: loginBarHeight - (textFieldOffsetY * 0.7071))
        self.passwordTextField.autocorrectionType = UITextAutocorrectionType.No
        self.passwordTextField.autocapitalizationType = UITextAutocapitalizationType.None
        self.passwordTextField.secureTextEntry = true
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.9)])
        self.passwordTextField.textColor = UIColor.whiteColor()
        self.passwordTextField.frame = CGRectMake(self.passwordBarImage.frame.origin.x + textFieldOffsetX, self.passwordBarImage.frame.origin.y - textFieldOffsetY, self.passwordBarImage.frame.width - textFieldOffsetX, loginBarHeight)
        self.view.addSubview(self.passwordTextField)
        
        self.emailTextField.delegate = self
        self.emailTextField.font = UIFont(name: "AvenirNext-Regular", size: loginBarHeight - (textFieldOffsetY * 0.7071))
        self.emailTextField.autocorrectionType = UITextAutocorrectionType.No
        self.emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        self.emailTextField.keyboardType = UIKeyboardType.EmailAddress
        self.emailTextField.adjustsFontSizeToFitWidth = true
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.9)])
        self.emailTextField.textColor = UIColor.whiteColor()
        self.emailTextField.frame = CGRectMake(self.emailBarImage.frame.origin.x + textFieldOffsetX, self.emailBarImage.frame.origin.y - textFieldOffsetY, self.emailBarImage.frame.width - textFieldOffsetX, loginBarHeight)
        self.view.addSubview(self.emailTextField)
        
        let signUpTextSize = self.view.frame.height * 0.025
        let signUpTextY = self.view.frame.height * 11.0 / 12.0 - signUpTextSize
        let signUpText1Width = signUpTextSize / 0.091
        let signUpText2Width = signUpTextSize / 0.242
        let totalWidth = signUpText1Width + signUpText2Width
        let signUpText1X = (self.view.frame.width - totalWidth) / 2.0
        
        self.signUpLabel1.text = "Don't have an account?"
        self.signUpLabel1.textColor = UIColor.whiteColor()
        self.signUpLabel1.textAlignment = NSTextAlignment.Center
        self.signUpLabel1.font = UIFont(name: "AvenirNext-Regular", size: signUpTextSize)
        self.signUpLabel1.frame = CGRectMake(signUpText1X, signUpTextY, signUpText1Width, signUpTextSize + 4)
        self.view.addSubview(signUpLabel1)
        
        let signUpText2X: CGFloat = self.signUpLabel1.frame.origin.x + signUpText1Width - 6
        self.signUpLabel2.text = "Sign up"
        self.signUpLabel2.textColor = UIColor.whiteColor()
        self.signUpLabel2.textAlignment = NSTextAlignment.Right
        self.signUpLabel2.font = UIFont(name: "AvenirNext-Bold", size: signUpTextSize)
        self.signUpLabel2.frame = CGRectMake(signUpText2X, signUpTextY, signUpText2Width, signUpTextSize + 4)
        self.view.addSubview(signUpLabel2)
        
        let buttonOffset: CGFloat = 10
        self.signUpButtonOverlay.frame = CGRectMake(self.signUpLabel1.frame.origin.x - buttonOffset, self.signUpLabel1.frame.origin.y - buttonOffset, totalWidth + (2 * buttonOffset), self.signUpLabel1.frame.height + (2 * buttonOffset))
        self.signUpButtonOverlay.addTarget(self, action: #selector(SignIn.launchSignUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.signUpButtonOverlay)
    }
    
    func showPopUp(errorMessage: Int) {
        print("<3")
        PopUp().showAlert(errorMessage, buttonColor: backgroundColour)
    }
    
    func signInButtonPressed(sender: UIButton) {
        print(":D")
        self.errorMessage = 0
        
        self.enteredEmail = self.emailTextField.text
        self.enteredPassword = self.passwordTextField.text
        print("\(self.enteredEmail), \(self.enteredPassword)")
        
        if self.enteredEmail == "" {
            errorMessage = 1
            self.showPopUp(errorMessage)
        } else if self.enteredPassword == "" && self.enteredEmail != "" {
            errorMessage = 2
            self.showPopUp(errorMessage)
        }
        
        if self.enteredEmail != "" && self.enteredPassword != "" {
            self.login()
        }
        
    }
    
    func login() {
        FIRAuth.auth()?.signInWithEmail(self.enteredEmail, password: self.enteredPassword) {
            user, error in
                
            if error != nil {
                
                if error?.code == 17011 {
                    self.errorMessage = 3
                } else if error?.code == 17999 {
                    self.errorMessage = 4
                }
                print(error?.code)
                self.showPopUp(self.errorMessage)
                    
            } else {
                print("next VC initiated")
                let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! SWRevealViewController
                mainVC.transitioningDelegate = self
                self.presentViewController(mainVC, animated: true, completion: nil)
            }
            
        }
        print("break")
    }
    
    func launchSignUp(sender: UIButton){
        print("hyyeeey")
        PopUp().showAlert(nil, buttonColor: self.backgroundColour)
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() != nil {
            if self.emailTextField.editing == true {
                self.view.frame.origin.y = 0.0 - self.view.frame.height / 6.0
            } else if self.passwordTextField.editing == true {
                self.view.frame.origin.y = 0.0 - self.view.frame.height / 5.0
            } else {
                self.view.frame.origin.y = 0.0
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            self.view.frame.origin.y = 0.0
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}












