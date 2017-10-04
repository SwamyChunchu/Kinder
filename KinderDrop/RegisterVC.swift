//
//  RegisterVC.swift
//  KinderDrop
//
//  Created by amit on 4/5/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import CoreLocation


class RegisterVC: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate,HMDiallingCodeDelegate,CLLocationManagerDelegate
{
    
    var socialGmailName = String()
    var socialGmail = String()
    var scrollViewLogin = UIScrollView()
    var logoImage = UIImageView()
    var userNameTF = ACFloatingTextfield()
    var emailTF = ACFloatingTextfield()
    var phoneTF = ACFloatingTextfield()
    var passWordTF = ACFloatingTextfield()
    var reEnterPWTF = ACFloatingTextfield()
     var countryCodeTF = ACFloatingTextfield()
    
    var userNMimg = UIImageView()
    var emailNMimg = UIImageView()
    var phoneimg = UIImageView()
    var passWordimg = UIImageView()
    var reEnterPWimg = UIImageView()
    
    var forgotPWbtn = UIButton()
    var registerButton = UIButton()
    var facebookLoginbtn = UIButton()
    var googleSigninButton = UIButton()
    var maleButton = UIButton()
    var femaleButton = UIButton()
    var countryCodeBtn = UIButton()
    
    var acceptImg = UIImageView()
    var acceptButton = UIButton()
    var acceptString = String()
    var conditionBtnButton = UIButton()
    
    
    var genderStr = String()
    var faceBookDic = NSDictionary()
    var diallingCode = HMDiallingCode()
    var locationManager = CLLocationManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var myString = String()
    var DeviceToken=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderStr = "m"
        myString = "0"
        acceptString = "1"
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
        }
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
//            currentLatitude = (locationManager.location?.coordinate.latitude)!
//            currentLongitude = (locationManager.location?.coordinate.longitude)!
        }else
        {
            let alertController = UIAlertController(title: "Kinder Drop", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                
                alertController.dismiss(animated: true, completion: nil)
            })
            // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            // alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.RegisterView()
        self.diallingCode.delegate = self
//        let ccStr:String = UserDefaults.standard.value(forKey: "savingCountryCode") as! String
//        self.countryCodeTF.text! = ccStr
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
             locationManager.requestWhenInUseAuthorization()
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
        }else{
             locationManager.requestWhenInUseAuthorization()
        }
        
        
        if myString == "0" {
               self.setUsersClosestCity()
        }
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }else{
            DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        
        acceptString = "1"
        acceptImg.image = #imageLiteral(resourceName: "CheckBokRight")
        acceptButton.isSelected = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
                let userLocation:CLLocation = locations.last!
                currentLatitude = (userLocation.coordinate.latitude)
                currentLongitude = (userLocation.coordinate.longitude)
            //locationManager.stopUpdatingHeading()
    }
    
   // MARK: Get Country Code  and Delegates
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        geoCoder.reverseGeocodeLocation(location)
        {
          (placemarks, error) -> Void in
            if ((error) != nil)
            {
                self.countryCodeTF.text! = ""
//     AFWrapperClass.alert(Constants.applicationName, message: String(format: "+%@",diallingCode), view: self)
            }
            else{
                    let placeArray = placemarks as [CLPlacemark]!
                    var placeMark: CLPlacemark!
                        placeMark = placeArray?[0]
                if placeMark.isoCountryCode != nil
                {
                    let iosCode = placeMark.isoCountryCode! as String
                    self.diallingCode.getForCountry(iosCode)
                }
            }
        }
    }
    
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        self.countryCodeTF.text! = String(format: "+%@",diallingCode)
        myString = "1"
        
    }
    public func failedToGetDiallingCode()
    {
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    
    
 // MARK: Register View
   
    func RegisterView ()
    {
        scrollViewLogin.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollViewLogin.contentSize=CGSize(width: self.view.frame.size.width, height: 900)
        self.view .addSubview(scrollViewLogin)
        
        logoImage.frame = CGRect(x:self.view.frame.size.width/2-120, y:10, width:240, height:100)
        logoImage.image = #imageLiteral(resourceName: "LogoImage")
        scrollViewLogin.addSubview(logoImage)
        
        userNameTF = ACFloatingTextfield()
        userNameTF.frame = CGRect(x:40, y:scrollViewLogin.frame.origin.y+120, width:self.view.frame.size.width-55, height:45)
        userNameTF.delegate = self
        userNameTF.placeholder = "Your Name"
        userNameTF.placeHolderColor=UIColor.darkGray
        userNameTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        userNameTF.lineColor=UIColor.darkGray
        userNameTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        userNameTF.autocorrectionType = UITextAutocorrectionType.no
        self.scrollViewLogin.addSubview(userNameTF)
        
        userNMimg.frame=CGRect(x:userNameTF.frame.origin.x-22, y:userNameTF.frame.origin.y+12, width:18, height:18)
        userNMimg.image = #imageLiteral(resourceName: "UserName")
        scrollViewLogin.addSubview(userNMimg)
        
        
        emailTF = ACFloatingTextfield()
        emailTF.frame = CGRect(x:40, y:userNameTF.frame.origin.y+60, width:self.view.frame.size.width-55, height:45)
        emailTF.delegate = self
        emailTF.placeholder = "Email address"
        emailTF.placeHolderColor=UIColor.darkGray
        emailTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        emailTF.lineColor=UIColor.darkGray
        emailTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        emailTF.keyboardType=UIKeyboardType.emailAddress
        emailTF.autocorrectionType = UITextAutocorrectionType.no
        emailTF.autocapitalizationType = .none
        self.scrollViewLogin.addSubview(emailTF)
        
        emailNMimg.frame=CGRect(x:emailTF.frame.origin.x-22, y:emailTF.frame.origin.y+12, width:18, height:18)
        emailNMimg.image = #imageLiteral(resourceName: "Email-Icon")
        scrollViewLogin.addSubview(emailNMimg)
        
        let grndetLbl = UILabel()
        grndetLbl.frame = CGRect(x:20, y:emailTF.frame.origin.y+65, width:120, height:30)
        grndetLbl.backgroundColor = UIColor.clear
        grndetLbl.text="Gender"
        grndetLbl.font =  UIFont(name:"Helvetica", size: 17)
        grndetLbl.textAlignment = .left
        grndetLbl.textColor=UIColor.darkGray
        scrollViewLogin.addSubview(grndetLbl)
        
        maleButton.frame = CGRect(x:20, y:grndetLbl.frame.origin.y+30, width:35, height:35)
        maleButton.backgroundColor = UIColor.clear
        maleButton.setImage(#imageLiteral(resourceName: "GenderChk"), for: UIControlState.normal)
        maleButton.addTarget(self, action: #selector(RegisterVC.maleButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.scrollViewLogin.addSubview(maleButton)
        
        
        let maleLabel = UILabel()
        maleLabel.frame = CGRect(x:maleButton.frame.origin.x+40, y:maleButton.frame.origin.y+2.5, width:40, height:30)
        maleLabel.backgroundColor = UIColor.clear
        maleLabel.text="Male"
        maleLabel.font =  UIFont(name:"Helvetica", size: 14)
        maleLabel.textAlignment = .left
        maleLabel.textColor=UIColor.darkGray
        scrollViewLogin.addSubview(maleLabel)
        
        femaleButton.frame = CGRect(x:maleLabel.frame.origin.x+40, y:grndetLbl.frame.origin.y+30, width:35, height:35)
        femaleButton.backgroundColor = UIColor.clear
        femaleButton.setImage(#imageLiteral(resourceName: "GenderUnchk"), for: UIControlState.normal)
        femaleButton.addTarget(self, action: #selector(RegisterVC.femaleButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.scrollViewLogin.addSubview(femaleButton)
        
        let femaleLabel = UILabel()
        femaleLabel.frame = CGRect(x:femaleButton.frame.origin.x+40, y:maleButton.frame.origin.y+2.5, width:50, height:30)
        femaleLabel.backgroundColor = UIColor.clear
        femaleLabel.text="Female"
        femaleLabel.font =  UIFont(name:"Helvetica", size: 14)
        femaleLabel.textAlignment = .left
        femaleLabel.textColor=UIColor.darkGray
        scrollViewLogin.addSubview(femaleLabel)
        
        
        phoneTF = ACFloatingTextfield()
        phoneTF.frame = CGRect(x:90, y:maleButton.frame.origin.y+70, width:self.view.frame.size.width-105, height:45)
        phoneTF.delegate = self
        phoneTF.placeholder = "Phone Number"
        phoneTF.placeHolderColor=UIColor.darkGray
        phoneTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        phoneTF.lineColor=UIColor.darkGray
        phoneTF.keyboardType=UIKeyboardType.numberPad
        phoneTF.autocorrectionType = UITextAutocorrectionType.no
        phoneTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        self.scrollViewLogin.addSubview(phoneTF)
        
        let ccView = UIView()
        ccView.frame =  CGRect(x:10, y:phoneTF.frame.origin.y, width:80, height:46)
        ccView.backgroundColor = UIColor.white
         scrollViewLogin.addSubview(ccView)
        
//        let cclineLbl = UILabel()
//        cclineLbl.frame = CGRect(x:0, y:44, width:ccView.frame.size.width-5, height:2)
//        cclineLbl.backgroundColor = UIColor.darkGray
//        ccView.addSubview(cclineLbl)
        
        phoneimg.frame=CGRect(x:5, y:13, width:18, height:18)
        phoneimg.image = #imageLiteral(resourceName: "Phone-icon")
        ccView.addSubview(phoneimg)
        
        countryCodeTF = ACFloatingTextfield()
        countryCodeTF.frame = CGRect(x:26, y:0, width:48, height:46)
        countryCodeTF.delegate = self
        countryCodeTF.placeholder = "CC"
        countryCodeTF.font = UIFont(name: "Helvetica", size: 14)
        countryCodeTF.placeHolderColor=UIColor.darkGray
        countryCodeTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        countryCodeTF.lineColor=UIColor.darkGray
        countryCodeTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        countryCodeTF.autocorrectionType = UITextAutocorrectionType.no
        ccView.addSubview(countryCodeTF)
        
        
        countryCodeBtn.frame = CGRect(x:0, y:0, width:75, height:46)
        countryCodeBtn.backgroundColor=UIColor.clear
        countryCodeBtn.addTarget(self, action: #selector(RegisterVC.countryCodeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        ccView.addSubview(countryCodeBtn)
        
        
        let lineGndeLbl = UILabel()
        lineGndeLbl.frame = CGRect(x:10, y:phoneTF.frame.origin.y-13, width:self.view.frame.size.width-20, height:1)
        lineGndeLbl.backgroundColor = UIColor.lightGray
        scrollViewLogin.addSubview(lineGndeLbl)

        passWordTF = ACFloatingTextfield()
        passWordTF.frame = CGRect(x:40, y:phoneTF.frame.origin.y+60, width:self.view.frame.size.width-55, height:45)
        passWordTF.delegate = self
        passWordTF.placeholder = "Password"
        passWordTF.placeHolderColor=UIColor.darkGray
        passWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        passWordTF.lineColor=UIColor.darkGray
        passWordTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        passWordTF.autocorrectionType = UITextAutocorrectionType.no
        passWordTF.isSecureTextEntry=true
        self.scrollViewLogin.addSubview(passWordTF)
        
        passWordimg.frame=CGRect(x:passWordTF.frame.origin.x-22, y:passWordTF.frame.origin.y+12, width:18, height:18)
        passWordimg.image = #imageLiteral(resourceName: "PassWord-icon")
        scrollViewLogin.addSubview(passWordimg)
        
        
        reEnterPWTF = ACFloatingTextfield()
        reEnterPWTF.frame = CGRect(x:40, y:passWordTF.frame.origin.y+60, width:self.view.frame.size.width-55, height:45)
        reEnterPWTF.delegate = self
        reEnterPWTF.placeholder = "Re-enter Password"
        reEnterPWTF.placeHolderColor=UIColor.darkGray
        reEnterPWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        reEnterPWTF.lineColor=UIColor.darkGray
        reEnterPWTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        reEnterPWTF.autocorrectionType = UITextAutocorrectionType.no
        reEnterPWTF.isSecureTextEntry=true
        self.scrollViewLogin.addSubview(reEnterPWTF)
        
        reEnterPWimg.frame=CGRect(x:reEnterPWTF.frame.origin.x-22, y:reEnterPWTF.frame.origin.y+12, width:18, height:18)
        reEnterPWimg.image = #imageLiteral(resourceName: "PassWord-icon")
        scrollViewLogin.addSubview(reEnterPWimg)
        
        let acceptView = UIView()
        acceptView.frame = CGRect(x:15, y:reEnterPWTF.frame.origin.y+65, width:300, height:30)
        self.scrollViewLogin.addSubview(acceptView)
        
        
        acceptImg.frame = CGRect(x:0, y:0, width:30, height:30)
        acceptImg.image = #imageLiteral(resourceName: "CheckBokRight")
         acceptView.addSubview(acceptImg)
        
        let acceptLabel = UILabel()
        acceptLabel.frame = CGRect(x:40, y:0, width:95, height:30)
        acceptLabel.backgroundColor = UIColor.clear
        acceptLabel.text="I accept all the"
        acceptLabel.font =  UIFont(name:"Helvetica", size: 14)
        acceptLabel.textColor=UIColor.darkGray
        acceptView.addSubview(acceptLabel)
        
        let termsLabel = UILabel()
        termsLabel.frame = CGRect(x:135, y:0, width:160, height:30)
        termsLabel.backgroundColor = UIColor.clear
        termsLabel.text="terms and conditions"
        termsLabel.font =  UIFont(name:"Helvetica-Bold", size: 14)
        termsLabel.textColor=#colorLiteral(red: 0.1698594987, green: 0.5732039809, blue: 0.6444239616, alpha: 1)
        acceptView.addSubview(termsLabel)
        
        
        acceptButton.frame = CGRect(x:0, y:0, width:50, height:30)
        acceptButton.addTarget(self, action: #selector(RegisterVC.acceptButtonAction(_:)), for: UIControlEvents.touchUpInside)
        acceptButton.layer.cornerRadius = 4
        acceptView.addSubview(acceptButton)
        acceptButton.isSelected = false
        
        conditionBtnButton.frame = CGRect(x:135, y:0, width:160, height:30)
        conditionBtnButton.addTarget(self, action: #selector(RegisterVC.aconditionButtonAction(_:)), for: UIControlEvents.touchUpInside)
        conditionBtnButton.layer.cornerRadius = 4
        acceptView.addSubview(conditionBtnButton)
        
        
        registerButton.frame = CGRect(x:15, y:reEnterPWTF.frame.origin.y+120, width:self.view.frame.size.width-30, height:45)
        registerButton.backgroundColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.titleLabel?.textAlignment = .left
        registerButton.addTarget(self, action: #selector(RegisterVC.registaerButtonAction(_:)), for: UIControlEvents.touchUpInside)
        registerButton.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(registerButton)
        
        
        let lineLbl = UILabel()
        lineLbl.frame = CGRect(x:0, y:registerButton.frame.origin.y+85, width:self.view.frame.size.width, height:1.5)
        lineLbl.backgroundColor = #colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        scrollViewLogin.addSubview(lineLbl)
        
        let orLabe = UILabel()
        orLabe.frame = CGRect(x:self.view.frame.size.width/2-130, y:lineLbl.frame.origin.y-15, width:260, height:30)
        orLabe.backgroundColor = UIColor.white
        orLabe.text="OR REGISTER WITH SOCIAL ACCOUNT"
        orLabe.font =  UIFont(name:"Helvetica", size: 12)
        orLabe.textAlignment = .center
        orLabe.textColor=UIColor.darkGray
        scrollViewLogin.addSubview(orLabe)
        
        facebookLoginbtn.frame = CGRect(x:self.view.frame.size.width/2-50, y:orLabe.frame.origin.y+50, width:40, height:40)
        facebookLoginbtn.setImage(#imageLiteral(resourceName: "facebook"), for: UIControlState.normal)
        facebookLoginbtn.addTarget(self, action: #selector(RegisterVC.faceBookSignUpButtonAction(_:)), for: UIControlEvents.touchUpInside)
        facebookLoginbtn.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(facebookLoginbtn)
        
        
        googleSigninButton.frame = CGRect(x:self.view.frame.size.width/2+10, y:orLabe.frame.origin.y+50, width:40, height:40)
        googleSigninButton.setImage(#imageLiteral(resourceName: "googleButton"), for: UIControlState.normal)
        googleSigninButton.addTarget(self, action: #selector(RegisterVC.googleSignUpButtonAction(_:)), for: UIControlEvents.touchUpInside)
        googleSigninButton.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(googleSigninButton)
        
        
        let loginButton = UIButton()
        loginButton.frame = CGRect(x:0, y:self.view.frame.size.height-50, width:self.view.frame.size.width, height:50)
        loginButton.backgroundColor=UIColor.white
        loginButton.setTitle("                                Login", for: .normal)
        loginButton.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 12)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.titleLabel?.textAlignment = .left
        loginButton.addTarget(self, action: #selector(RegisterVC.goLoginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginButton)
        
        
        let accntLabel = UILabel()
        accntLabel.frame = CGRect(x:self.view.frame.size.width/2-110, y:loginButton.frame.origin.y+10, width:140, height:30)
        //accntLabel.backgroundColor=UIColor.yellow
        accntLabel.text="Have an Account?"
        accntLabel.font =  UIFont(name:"Helvetica", size: 12)
        accntLabel.textAlignment = .right
        accntLabel.textColor=UIColor.darkGray
        self.view.addSubview(accntLabel)
        
        let btmLine = UILabel()
        btmLine.frame = CGRect(x:0, y:loginButton.frame.origin.y-1, width:self.view.frame.size.width, height:1.5)
        btmLine.backgroundColor=UIColor.darkGray
        self.view.addSubview(btmLine)
    }
    
    func countryCodeButtonAction(_ sender: UIButton!) {
        let vc = SLCountryPickerViewController()
        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
        self.diallingCode.getForCountry(code!)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func acceptButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            acceptImg.image = #imageLiteral(resourceName: "CheckBokRight")
            sender.isSelected = false
            acceptString = "1"
        } else {
            acceptImg.image = #imageLiteral(resourceName: "UnChkSquare")
            sender.isSelected = true
            acceptString = "0"
        }
    }
    func aconditionButtonAction(_ sender: UIButton!) {
        
        let baseURL: String  = String(format: "%@termscondition/",Constants.mainURL)
        let params = ""
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsVC") as? TermsAndConditionsVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.displayLblStr = "Terms & Conditions"
                    myVC?.hiddenStr = "NO"
                    myVC?.textStr = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "text") as! String
                    
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message:"Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    // MARK: MaleButton Action:
    func maleButtonAction(_ sender: UIButton!) {
        maleButton.setImage(#imageLiteral(resourceName: "GenderChk"), for: UIControlState.normal)
        femaleButton.setImage(#imageLiteral(resourceName: "GenderUnchk"), for: UIControlState.normal)
        genderStr = "m"
    }
    // MARK: FemaleButton Action:
    func femaleButtonAction(_ sender: UIButton!) {
        
       femaleButton.setImage(#imageLiteral(resourceName: "GenderChk"), for: UIControlState.normal)
       maleButton.setImage(#imageLiteral(resourceName: "GenderUnchk"), for: UIControlState.normal)
        genderStr = "f"
    }
    // MARK: RegisterButton Action:
    func registaerButtonAction(_ sender: UIButton!) {
        var message = String()
        if (userNameTF.text?.isEmpty)!
        {
            userNameTF.becomeFirstResponder()
            message = "Please enter User Name"
        }
        else if !AFWrapperClass.isValidEmail(emailTF.text!)
        {
            emailTF.becomeFirstResponder()
            message = "Please enter valid Email"
        }
        else if (countryCodeTF.text?.isEmpty)!
        {
            message = "Please choose country code"
        }
        else if (phoneTF.text?.isEmpty)!
        {
            phoneTF.becomeFirstResponder()
            message = "Please enter Phone number"
        }
        else if (passWordTF.text?.characters.count)! < 6
        {
            message = "Password sould be minimum 6 characters"
        }
        else if !(passWordTF.text == reEnterPWTF.text)
        {
            message = "Password doesn't match please try again"
        }
        else if acceptString == "0"
        {
            message = "Please accept all the terms & conditions"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.simpleRegistarationMethod()
        }
    }
 
    func simpleRegistarationMethod () -> Void
    {
        //let paramse = ["name": userNameTF.text!, "email": emailTF.text!, "mobile": phoneTF.text!, "password": passWordTF.text!, "is_social": "0", "gender": genderStr] as [String : String]
      var mobileString = String(format:"%@%@",countryCodeTF.text!,phoneTF.text!)
        mobileString = String(mobileString.replacingOccurrences(of: "+", with: "%2B"))
      let pwString = passWordTF.text!.trimmingCharacters(in: .whitespaces)
        
        let baseURL: String  = String(format:"%@Registration/",Constants.mainURL)
        let params = "name=\(userNameTF.text!)&email=\(emailTF.text!)&mobile=\(mobileString)&password=\(pwString)&gender=\(genderStr)&is_social=\("0")&device_type=ios&device_id=\(DeviceToken)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
             DispatchQueue.main.async {
            AFWrapperClass.svprogressHudDismiss(view: self)
            let responceDic:NSDictionary = jsonDic as NSDictionary
            if (responceDic.object(forKey: "status") as! Bool) == true
            {
                let idNumber:NSNumber = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! NSNumber
                let id:String = idNumber.stringValue
                UserDefaults.standard.set(id, forKey: "saveUserID")
                UserDefaults.standard.synchronize()
                
                let registerIsSocial:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "is_social") as! String
                
                UserDefaults.standard.set(registerIsSocial, forKey: "saveRegSocial")
                UserDefaults.standard.synchronize()
                
               UserDefaults.standard.set("LoginSuccess", forKey: "success")
               UserDefaults.standard.synchronize()
                
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                self.navigationController?.pushViewController(myVC!, animated: true)
            }
            else
            {
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: "Mobile or Email already exist", view: self)
            }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    // MARK: FaceBookLoginButton Action:
    func faceBookSignUpButtonAction(_ sender: UIButton!) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.faceBookDic = result as! [String : AnyObject] as NSDictionary
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistarationVC") as? SocialRegistarationVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.emailStr = self.faceBookDic.object(forKey: "email") as! String
                    myVC?.nameStr = self.faceBookDic.object(forKey: "name") as! String
                    myVC?.displayNameStr = "Register With Facebook"
                }
            })
        }
    }

    // MARK: GoogleSignLoginButton Action:
    func googleSignUpButtonAction(_ sender: UIButton!)
    {
         GIDSignIn.sharedInstance().signOut()
        let sighIn:GIDSignIn = GIDSignIn.sharedInstance()
        sighIn.delegate = self;
        sighIn.uiDelegate = self;
        sighIn.shouldFetchBasicProfile = true
        sighIn.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/userinfo.profile","https://www.googleapis.com/auth/plus.me"];
        sighIn.clientID = "109567490005-s45491icv66ivnh419adbkk1ps8jht4l.apps.googleusercontent.com"
        sighIn.signIn()
        GIDSignIn.sharedInstance().signOut()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        AFWrapperClass.svprogressHudDismiss(view: self);
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            return
        }
        reportAuthStatus()
       // socialGmailName = user.profile.name
      //  socialGmail = user.profile.email
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistarationVC") as? SocialRegistarationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        myVC?.emailStr = user.profile.email
        myVC?.nameStr = user.profile.name
        myVC?.displayNameStr = "Register With Google"
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
        }else
        {
        }
    }
    func reportAuthStatus() -> Void {
        let googleUser:GIDGoogleUser = GIDSignIn.sharedInstance().currentUser
        if (googleUser.authentication != nil)
        {
        }else
        {
        }
    }
    func refreshUserInfo() -> Void {
        if GIDSignIn.sharedInstance().currentUser.authentication == nil {
            return
        }
        if !GIDSignIn.sharedInstance().currentUser.profile.hasImage {
            return
        }
    }
    // MARK: Go LoginButton Action:
    func goLoginButtonAction(_ sender: UIButton!)
    {
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
//        self.navigationController?.pushViewController(myVC!, animated: true)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }    
    func textField(_ textField: UITextField, shouldChangeCharactersIn shouldChangeCharactersInRangerange: NSRange, replacementString string: String)-> Bool
        
    {
        let newString = ((textField.text)! as NSString).replacingCharacters(in: shouldChangeCharactersInRangerange, with: string)
        
        let newLength = newString.characters.count
        
        if (textField == phoneTF)
        {
            if (newLength == 12)
            {
                phoneTF.resignFirstResponder()
                return false
            }
            
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
