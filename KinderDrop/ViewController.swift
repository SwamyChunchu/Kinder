//
//  ViewController.swift
//  KinderDrop
//
//  Created by amit on 4/5/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import GoogleSignIn


class ViewController: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate,HMDiallingCodeDelegate
{
  
    var scrollViewLogin = UIScrollView()
    var logoImage = UIImageView()
    var userNameTF = ACFloatingTextfield()
    var passWordTF = ACFloatingTextfield()
    var userNMimg = UIImageView()
    var passwordNMimg = UIImageView()
    var forgotPWbtn = UIButton()
    var loginButton = UIButton()
    var facebookLoginbtn = UIButton()
    var googleSigninButton = UIButton()
    var dataArray = NSArray()
    var faceBookDic = NSDictionary()
    var emailStringSocial = String()
    var socialName = String()
    var displayname = String()
    
    var baseURL = String()
    var params = String()
    var mobileFullString = String()
    var diallingCode = HMDiallingCode()
    let splashView = UIView()
    var appDelegate = AppDelegate()
    var DeviceToken = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.diallingCode.delegate = self
        self.LoginView()
        
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            
        }else{
            
            let alertController = UIAlertController(title: "Kinder Drop", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                
            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                
                alertController.dismiss(animated: true, completion: nil)
            })
 
           // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
           // alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }else{
            DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
    }
//    func gotomainmenuview(_ theTimer: Timer) {
//        splashView.isHidden = true
//    }

     // MARK: Login view Method
    
    func LoginView ()
    {
        scrollViewLogin.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-51)
        scrollViewLogin.contentSize=CGSize(width: self.view.frame.size.width, height: 600)
        self.view .addSubview(scrollViewLogin)
        
        logoImage.frame = CGRect(x:self.view.frame.size.width/2-120, y:30, width:240, height:100)
        logoImage.image = #imageLiteral(resourceName: "LogoImage")
        scrollViewLogin.addSubview(logoImage)
        
        userNameTF = ACFloatingTextfield()
        userNameTF.frame = CGRect(x:40, y:scrollViewLogin.frame.origin.y+140, width:self.view.frame.size.width-55, height:45)
        userNameTF.delegate = self
        userNameTF.placeholder = "Email/Mobile(with out country code)"
        userNameTF.placeHolderColor=UIColor.darkGray
        userNameTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        userNameTF.lineColor=UIColor.darkGray
        userNameTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        userNameTF.autocorrectionType = UITextAutocorrectionType.no
        userNameTF.autocapitalizationType = .none
        self.scrollViewLogin.addSubview(userNameTF)
        
        userNMimg.frame=CGRect(x:userNameTF.frame.origin.x-22, y:userNameTF.frame.origin.y+12, width:18, height:18)
        userNMimg.image = #imageLiteral(resourceName: "UserName")
        scrollViewLogin.addSubview(userNMimg)
        
        passWordTF = ACFloatingTextfield()
        passWordTF.frame = CGRect(x:40, y:userNameTF.frame.origin.y+60, width:self.view.frame.size.width-55, height:45)
        passWordTF.delegate = self
        passWordTF.placeholder = "Password"
        passWordTF.placeHolderColor=UIColor.darkGray
        passWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        passWordTF.lineColor=UIColor.darkGray
        passWordTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        passWordTF.isSecureTextEntry=true
        self.scrollViewLogin.addSubview(passWordTF)
        
        passwordNMimg.frame=CGRect(x:passWordTF.frame.origin.x-22, y:passWordTF.frame.origin.y+12, width:18, height:18)
        passwordNMimg.image = #imageLiteral(resourceName: "PassWord-icon")
        scrollViewLogin.addSubview(passwordNMimg)
        
        forgotPWbtn.frame = CGRect(x:passWordTF.frame.size.width-110, y:passWordTF.frame.origin.y+50, width:145, height:40)
        forgotPWbtn.backgroundColor=UIColor.clear
        forgotPWbtn.setTitle("Forgot password?", for: .normal)
        forgotPWbtn.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        forgotPWbtn.setTitleColor(UIColor.darkGray, for: .normal)
        forgotPWbtn.titleLabel?.textAlignment = .right
        forgotPWbtn.addTarget(self, action: #selector(ViewController.forgotButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.scrollViewLogin.addSubview(forgotPWbtn)
        
        loginButton.frame = CGRect(x:15, y:passWordTF.frame.origin.y+100, width:self.view.frame.size.width-30, height:45)
        loginButton.backgroundColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.textAlignment = .left
        loginButton.addTarget(self, action: #selector(ViewController.loginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        loginButton.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(loginButton)
        
        
        let lineLbl = UILabel()
        lineLbl.frame = CGRect(x:0, y:loginButton.frame.origin.y+85, width:self.view.frame.size.width, height:1.5)
        lineLbl.backgroundColor = #colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        scrollViewLogin.addSubview(lineLbl)
        
        let orLabe = UILabel()
        orLabe.frame = CGRect(x:self.view.frame.size.width/2-130, y:lineLbl.frame.origin.y-15, width:260, height:30)
         orLabe.backgroundColor = UIColor.white
        orLabe.text="OR LOGIN WITH SOCIAL ACCOUNT"
        orLabe.font =  UIFont(name:"Helvetica", size: 12)
        orLabe.textAlignment = .center
        orLabe.textColor=UIColor.darkGray
        scrollViewLogin.addSubview(orLabe)
        
        facebookLoginbtn.frame = CGRect(x:self.view.frame.size.width/2-50, y:orLabe.frame.origin.y+50, width:40, height:40)
        facebookLoginbtn.setImage(#imageLiteral(resourceName: "facebook"), for: UIControlState.normal)
        facebookLoginbtn.addTarget(self, action: #selector(ViewController.faceBookloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        facebookLoginbtn.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(facebookLoginbtn)
        
        
        googleSigninButton.frame = CGRect(x:self.view.frame.size.width/2+10, y:orLabe.frame.origin.y+50, width:40, height:40)
        googleSigninButton.setImage(#imageLiteral(resourceName: "googleButton"), for: UIControlState.normal)
        googleSigninButton.addTarget(self, action: #selector(ViewController.googleloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        googleSigninButton.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(googleSigninButton)
        
        let registerButton = UIButton()
        registerButton.frame = CGRect(x:0, y:self.view.frame.size.height-50, width:self.view.frame.size.width, height:50)
        registerButton.setTitle("                                  Register", for: .normal)
        registerButton.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 12)
        registerButton.setTitleColor(UIColor.black, for: .normal)
        registerButton.titleLabel?.textAlignment = .left
        registerButton.addTarget(self, action: #selector(ViewController.goRegisterButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(registerButton)
        
        let accntLabel = UILabel()
        accntLabel.frame = CGRect(x:self.view.frame.size.width/2-110, y:registerButton.frame.origin.y+10, width:140, height:30)
        //accntLabel.backgroundColor=UIColor.yellow
        accntLabel.text="Don't have an Account?"
        accntLabel.font =  UIFont(name:"Helvetica", size: 12)
        accntLabel.textAlignment = .right
        accntLabel.textColor=UIColor.darkGray
        self.view.addSubview(accntLabel)
        
        let btmLine = UILabel()
        btmLine.frame = CGRect(x:0, y:registerButton.frame.origin.y-1, width:self.view.frame.size.width, height:1.5)
       btmLine.backgroundColor=UIColor.darkGray
        self.view.addSubview(btmLine)
    }
    
    
    // MARK: DialingCodeDelegates:
    
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        let countryCode = String(format: "+%@",diallingCode)
        mobileFullString = String(format: "%@%@",countryCode,userNameTF.text!)
        mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
        
         self.simpleLoginMethod()
    }
    public func failedToGetDiallingCode() {
        
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    
     // MARK: ForgotButton Action:
    
    func forgotButtonAction(_ sender: UIButton!) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswodVC") as? ForgotPasswodVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    // MARK: LoginButton Action:
    func loginButtonAction(_ sender: UIButton!) {
        
         var message = String()
      
        if (userNameTF.text?.isEmpty)!
        {
            message = "Please enter Email/Mobile Number"
        }
        else if (passWordTF.text?.isEmpty)!
        {
            message = "Please enter Password"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
        }else{
            let str: String = userNameTF.text!
            if str.isNumber == true
            {
                let vc = SLCountryPickerViewController()
                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
                    self.diallingCode.getForCountry(code!)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if str.isNumber == false
            {
                mobileFullString = userNameTF.text!
                self.simpleLoginMethod()
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Email/Mobile Number", view: self)
            }
        }
    }
    
    func simpleLoginMethod () -> Void
    {
        self.view.endEditing(true)
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }else{
            DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
            
        }
        
        baseURL  = String(format: "%@login/",Constants.mainURL)
        params = "mobile=\(mobileFullString)&password=\(passWordTF.text!)&is_social=\("0")&device_type=ios&device_id=\(DeviceToken)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let responceDic:NSDictionary = jsonDic as NSDictionary
    
            if (responceDic.object(forKey: "status") as! Bool) == true
            {
                let id:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! String
                
                UserDefaults.standard.set(id, forKey: "saveUserID")
                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.set("LoginSuccess", forKey: "success")
                UserDefaults.standard.synchronize()
                
                let registerIsSocial:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "is_social") as! String
                
                UserDefaults.standard.set(registerIsSocial, forKey: "saveRegSocial")
                UserDefaults.standard.synchronize()
         
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                self.navigationController?.pushViewController(myVC!, animated: true)
            }
            else
            {
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: "Wrong Credentials", view: self)
            }
            
                }
        })
        { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
        
//        var request = URLRequest(url: URL(string: "http://think360.in/kindr/api/index.php/12345/login")!)
//        request.httpMethod = "POST"
//        let postString = "mobile=nitish.think360@gmail.com&password=123456&is_social=0"
//        request.httpBody = postString.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                // check for fundamental networking error
//                return
//            }
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                // check for http errors

//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            
//
//            if let data = responseString?.data(using: String.Encoding.utf8) {
//                do {
//                    let jsonDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
//                     let dic:NSDictionary = (jsonDic as AnyObject) as! NSDictionary
//                    
//
//                } catch {
//                    
//                }
//            }
//        }
//        task.resume()
 
    }
 
    // MARK: FaceBookLoginButton Action:
    func faceBookloginButtonAction(_ sender: UIButton!) {
        
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
                    self.emailStringSocial = self.faceBookDic.object(forKey: "email") as! String
                    self.socialName  = self.faceBookDic.object(forKey: "name") as! String
                    self.displayname = "Register With Facebook"
                    self.socialLoginMethod()
                }
            })
        }
    }
 
    func socialLoginMethod () -> Void
    {
        self.view.endEditing(true)
        
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }else{
            DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
             }
        let baseURL: String  = String(format: "%@login/",Constants.mainURL)
        let params = "mobile=\(self.emailStringSocial)&is_social=\("1")&device_type=ios&device_id=\(DeviceToken)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {

                    let id:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! String
                    
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
                    
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistarationVC") as? SocialRegistarationVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.emailStr = self.emailStringSocial
                    myVC?.nameStr = self.socialName
                    myVC?.displayNameStr = self.displayname
                    
                    AFWrapperClass.alert(Constants.applicationName, message: "You are not register with  Kinder Drop. Please register..", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    // MARK: GoogleSignLoginButton Action:
    func googleloginButtonAction(_ sender: UIButton!)
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
        AFWrapperClass.svprogressHudShow(title: "Getting Details...", view: self)
        emailStringSocial = user.profile.email
        socialName = user.profile.name
        displayname = "Register With Google"
        self.socialLoginMethod()
        
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
   
    // MARK: RegisterButton Action:
    func goRegisterButtonAction(_ sender: UIButton!)
    {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        
    }

     // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




