//
//  UpdatePWVC.swift
//  KinderDrop
//
//  Created by think360 on 01/06/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class UpdatePWVC: UIViewController {
    
    @IBOutlet weak var newPasswrdTF: ACFloatingTextfield!
    @IBOutlet weak var confirmPwTF: ACFloatingTextfield!
    var userID = String()
    var pwString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        var message = String()
        if (newPasswrdTF.text?.characters.count)! < 6
        {
            message = "Password sould be minimum 6 characters"
        }
        else if !(newPasswrdTF.text == confirmPwTF.text)
        {
            message = "Confirm Password doesn't match please try again"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.updatePassWordApiMethod()
        }
    }
    func updatePassWordApiMethod () -> Void
    {
        self.view.endEditing(true)
        let pwString = newPasswrdTF.text!.trimmingCharacters(in: .whitespaces)
        let baseURL  = String(format: "%@useredit/",Constants.mainURL)
        let params:String = String(format:"user_id=%@&name=%@&email=%@&mobile=%@&gender=%@&password=%@&profilepic=%@&address=%@&is_social=%@&Address2=%@&Emergency_contact=%@&City=%@&Province=%@&Postl_code=%@",userID,"","","","",pwString,"","","","","","","","")
       
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    AFWrapperClass.alert(Constants.applicationName, message: "Your password changed successfully please login.", view: self)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Something went wrong Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
