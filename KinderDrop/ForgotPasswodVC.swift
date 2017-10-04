//
//  ForgotPasswodVC.swift
//  KinderDrop
//
//  Created by amit on 4/20/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ForgotPasswodVC: UIViewController,HMDiallingCodeDelegate,UITextFieldDelegate
{
    @IBOutlet weak var mobileTF: ACFloatingTextfield!
    var baseURL = String()
    var params = String()
    var mobileFullString = String()
    var diallingCode = HMDiallingCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTF.delegate = self
        self.diallingCode.delegate = self
    }
    
// MARK: DialingCodeDelegates:
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        let countryCode = String(format: "+%@",diallingCode)
        mobileFullString = String(format: "%@%@",countryCode,mobileTF.text!)
        mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
        self.view.endEditing(true)
        self.forgotOTPapiMethod()
    }
    public func failedToGetDiallingCode() {
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }

    @IBAction func sendOTPbuttonAction(_ sender: Any) {
        var message = String()
        if (mobileTF.text?.isEmpty)!
        {
            message = "Please enter Email/Mobile Number"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            let str: String = mobileTF.text!
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
                mobileFullString = mobileTF.text!
                self.forgotOTPapiMethod()
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Email/Mobile Number", view: self)
            }
        }
    }
    
    func forgotOTPapiMethod () -> Void
    {
        self.view.endEditing(true)
        baseURL  = String(format: "%@forget_password/",Constants.mainURL)
        params = "mobile=\(mobileFullString)"

        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    if responceDic.object(forKey:"code") as! NSNumber == 2
                    {
                    let id:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! String
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTP") as? ConfirmOTP
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.userID = id
                    AFWrapperClass.alert(Constants.applicationName, message: "OTP Send Successfully.", view: self)
                    }
                    else if responceDic.object(forKey:"code") as! NSNumber == 3
                    {
                    let alertController = UIAlertController(title: "Kinder Drop", message: "Password sent to your email.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                      _ = self.navigationController?.popViewController(animated: true)
                    alertController.dismiss(animated: true, completion: nil)
                            })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    }
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "User not exist", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
