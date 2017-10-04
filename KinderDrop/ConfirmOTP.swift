//
//  ConfirmOTP.swift
//  KinderDrop
//
//  Created by amit on 4/20/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ConfirmOTP: UIViewController,UITextFieldDelegate
{
 
    var userID = String()
    var baseURL = String()
    var params = String()
    @IBOutlet weak var otpTF: ACFloatingTextfield!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTF.delegate = self
    }
    
    @IBAction func otpTFaction(_ sender: ACFloatingTextfield) {
        if sender.text?.trimmingCharacters(in: .whitespaces).characters.count == 4
        {
            self.view.endEditing(true)
        }
    }
    
    @IBAction func confirmOTPbuttonAction(_ sender: Any) {
        var message = String()
        if (otpTF.text?.characters.count)! != 4
        {
            message = "Please enter four digit OTP"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.confirmOTPapiMethod()
        }
    }
    func confirmOTPapiMethod () -> Void
    {
        self.view.endEditing(true)
        baseURL  = String(format: "%@verify_otp/",Constants.mainURL)
        params = "user_id=\(userID)&otp=\(otpTF.text!)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                   let id:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! String
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePWVC") as? UpdatePWVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.userID = id
                   }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Otp not verify please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    @IBAction func resendOTPbtnAction(_ sender: Any) {
        self.view.endEditing(true)
        baseURL  = String(format: "%@resend_otp/",Constants.mainURL)
        params = "user_id=\(userID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    let id:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! String
                    self.userID = id
                    AFWrapperClass.alert(Constants.applicationName, message: "OTP Send Successfully.", view: self)
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
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        //let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
