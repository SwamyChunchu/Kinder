//
//  SocialRegistarationVC.swift
//  KinderDrop
//
//  Created by amit on 4/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class SocialRegistarationVC: UIViewController,HMDiallingCodeDelegate,UITextFieldDelegate{

    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var nameTF: ACFloatingTextfield!
    @IBOutlet weak var emailTF: ACFloatingTextfield!
    @IBOutlet weak var phoneTF: ACFloatingTextfield!
    
    @IBOutlet weak var codeLabel: UILabel!
    
    var countryCodeStr = String()
    var genderStr = String()
    var accetString = String()
    var mobileFullString = String()
    var diallingCode = HMDiallingCode()
    var emailStr : String!
    var nameStr : String!
    
    @IBOutlet weak var nameLabel: UILabel!
    var displayNameStr : String!
    var DeviceToken=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.diallingCode.delegate = self
        countryCodeStr = ""
        codeLabel.text! = "CC"
        genderStr = "m"
        accetString = "1"
        acceptButton.isSelected = false
        
        self.nameLabel.text! = displayNameStr
        self.emailTF.text! = emailStr
        self.nameTF.text! = nameStr
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
    // MARK: MaleButton
    @IBAction func maleButtonAction(_ sender: Any) {
        maleButton.setImage(#imageLiteral(resourceName: "GenderChk"), for: UIControlState.normal)
        femaleButton.setImage(#imageLiteral(resourceName: "GenderUnchk"), for: UIControlState.normal)
        genderStr = "m"
    }
    // MARK: Female Button Action
    @IBAction func famaleButtonAction(_ sender: Any) {
        femaleButton.setImage(#imageLiteral(resourceName: "GenderChk"), for: UIControlState.normal)
        maleButton.setImage(#imageLiteral(resourceName: "GenderUnchk"), for: UIControlState.normal)
        genderStr = "f"
    }
    
    // MARK: Accept terms button
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            accetString = "1"
            acceptButton.setImage(UIImage(named: "CheckBokRight"), for: .normal)
            sender.isSelected = false
            } else {
            accetString = "0"
            acceptButton.setImage(UIImage(named: "UnChkSquare"), for: .normal)
            sender.isSelected = true
            }
    }
    
    // MARK: Registration button
    @IBAction func registrationButtonAction(_ sender: Any) {
        var message = String()
        if (phoneTF.text?.isEmpty)!
        {
            message = "Please enter Phone number"
        }
        else if countryCodeStr == ""
        {
            message = "Please choose country code"
        }
        else if accetString == "0"
        {
             message = "Please accept the all terms and conditions"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
           self.SocialRegistarationMethod()
        }
    }
    
    func SocialRegistarationMethod () -> Void
    {
        mobileFullString = String(format: "%@%@",countryCodeStr,phoneTF.text!)
        mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
        
        let baseURL: String  = String(format:"%@Registration/",Constants.mainURL)
        let params = "name=\(nameTF.text!)&email=\(emailTF.text!)&mobile=\(mobileFullString)&gender=\(genderStr)&is_social=\("1")&device_type=ios&device_id=\(DeviceToken)"
        
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
    
    // MARK: Get Country Code:
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        let vc = SLCountryPickerViewController()
        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
            self.diallingCode.getForCountry(code!)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: DialingCodeDelegates:
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        let countryCode = String(format: "+%@",diallingCode)
       // mobileFullString = String(format: "%@%@",countryCode,phoneTF.text!)
        countryCodeStr = countryCode
        codeLabel.text! = countryCodeStr
        self.view.endEditing(true)
    }
    public func failedToGetDiallingCode() {
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
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
    
    
    @IBAction func backButtonAction(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
