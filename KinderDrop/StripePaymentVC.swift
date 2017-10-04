//
//  StripePaymentVC.swift
//  KinderDrop
//
//  Created by amit on 4/18/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Stripe


class StripePaymentVC: UIViewController,TPFloatRatingViewDelegate,UITextViewDelegate,kDropDownListViewDelegate {

    var Dropobj = DropDownListView()
    var dropDownView = UIView()
    
    @IBOutlet weak var cardNumTF: ACFloatingTextfield!
    @IBOutlet weak var monthTF: ACFloatingTextfield!
    @IBOutlet weak var yearTF: ACFloatingTextfield!
    @IBOutlet weak var cvvTF: ACFloatingTextfield!
    
    @IBOutlet weak var payBtnStripe: UIButton!
    var amountString = String()
    var userID = String()
    var  dateString = String()
    var slotTypeString = String()
    var dayCareID = String()
    var childIDsAry = NSArray()
    var paymentID = String()
    var childIDstring = String()
    
    var monthArray = NSArray()
    var yearArray = NSArray()
    var yearSelectdArray = NSArray()
     var selectedStr = NSString()
    var selecteYearStr = String()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
        
        payBtnStripe.setTitle(String(format:"Pay $%@",amountString), for: .normal)
        
        monthArray = ["01","02","03","04","05","06","07","08","09","10","11","12"]

        yearArray = ["2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040","2041","2042","2043","2044","2045","2046","2047","2048","2049","2050"]
        
        yearSelectdArray = ["17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50"]

       // print(yearArray.count, yearSelectdArray.count)
    }
    
    
    
    //MARK: DropDown Delegates:
    func showPopUp(withTitle popupTitle: String, withOption arrOptions: [Any], xy point: CGPoint, size: CGSize, isMultiple: Bool)
    {
        Dropobj.fadeOut()
        dropDownView.frame = CGRect(x:0 , y:0 , width: self.view.frame.size.width, height:self.view.frame.size.height)
        dropDownView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
        self.view.addSubview(dropDownView)
        Dropobj = DropDownListView(title: popupTitle, options: arrOptions, xy: point, size: size, isMultiple: isMultiple)
        
        Dropobj.delegate = self
        Dropobj.show(in: dropDownView, animated: true)
        Dropobj.setBackGroundDropDown_R(36.0, g: 146.0, b: 165.0, alpha: 0.90)
    }
    
    
    @IBAction func monthButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.selectedStr = "Month"
        self.showPopUp(withTitle: "Select Month", withOption: self.monthArray as! [Any], xy: CGPoint(x:self.view.frame.size.width/2-120 ,y: self.view.frame.size.height/2-150), size: CGSize(width: 240 , height: 300), isMultiple: false)
    }
    
    @IBAction func yearButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.selectedStr = "Year"
        self.showPopUp(withTitle: "Select Year", withOption: self.yearArray as! [Any], xy: CGPoint(x:self.view.frame.size.width/2-120 ,y: self.view.frame.size.height/2-150), size: CGSize(width: 240 , height: 300), isMultiple: false)
    }
    
    
    
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int) {
        if selectedStr == "Month"
        {
           self.monthTF.text! = (monthArray.object(at: anIndex) as! NSString) as String
            dropDownView.removeFromSuperview()
        }
        else if selectedStr == "Year"
        {
            self.yearTF.text! = (yearArray.object(at: anIndex) as! NSString) as String
            self.selecteYearStr = (yearSelectdArray.object(at: anIndex) as! NSString) as String
            dropDownView.removeFromSuperview()
        }
        
    }
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
        // Multiple Selection
    }
    func dropDownListViewDidCancel() {
        // DpopDown Calcelled
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Dropobj.fadeOut()
        dropDownView.removeFromSuperview()
    }
    
    
    
    
    
    
    @IBAction func stripePaymentButtonAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        
        var message = String()
        if (cardNumTF.text?.isEmpty)!
        {
            message = "Please enter card number"
        }
        else if !(cardNumTF.text?.characters.count == 16 || cardNumTF.text?.characters.count == 19)
        {
            message = "Please enter valid card number"
        }
        else if  (monthTF.text?.isEmpty)!
        {
            message = "Please select month"
        }
       
        else if (yearTF.text?.isEmpty)!
        {
            message = "Please select year"
        }
        
        else if !((cvvTF.text?.characters.count) == 3)
        {
            message = "Please enter valid CVV"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            
            let stripCard = STPCard()
            stripCard.number = self.cardNumTF.text!
            stripCard.cvc = self.cvvTF.text!
            stripCard.expMonth = UInt(self.monthTF.text!)!
            stripCard.expYear = UInt(self.selecteYearStr)!
            
            print(self.monthTF.text!,self.selecteYearStr)
            //  let underlyingError: NSError?
            //  stripCard.validateCardReturningError(underlyingError)
            //  if underlyingError != nil {
            //  self.handleError(underlyingError!)
            //  return
            //  }
            STPAPIClient.shared().createToken(with: stripCard, completion: { (token, error) -> Void in
                if error != nil {
                    self.handleError(error! as NSError)
              return
            }
                self.postStripeToken(token!)
            })
        }
    }
    func handleError(_ error: NSError) {
        AFWrapperClass.svprogressHudDismiss(view: self)
        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
    }
    func postStripeToken(_ token: STPToken) {
        
            let baseURL: String  = String(format:"%@stripe/",Constants.mainURL)
            let params = "amount=\(amountString)&token=\(token.tokenId)"
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                DispatchQueue.main.async {
                    
                    let responceDic:NSDictionary = jsonDic as NSDictionary
                    if (responceDic.object(forKey: "status") as! Bool) == true
                    {
                       // AFWrapperClass.svprogressHudDismiss(view: self)
                        self.paymentID = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "charge_id") as! String
                        self.bokkingKinderAPiMethod()
                        print(self.paymentID)
                    }
                    else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: "Your booking not successful please try again.", view: self)
                    }
                }
            }) { (error) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }

    func bokkingKinderAPiMethod() -> Void
    {
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: childIDsAry, options: [])
        childIDstring = (String(data: jsonData!, encoding: .utf8)! as NSString) as String
        let baseURL: String  = String(format:"%@addbooking/",Constants.mainURL)
        
        let params = "amount=\(amountString)&userid=\(userID)&daycareid=\(dayCareID)&child_id=\(childIDstring)&booking_date=\(dateString)&booking_type=\(slotTypeString)&payment_id=\(paymentID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
//                    let bookId:NSNumber = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "booking_id") as! NSNumber
//                    self.bookingID = String(describing: bookId)
                    
            let alertController = UIAlertController(title: "Kinder Drop", message: "Your Booking is Successful.", preferredStyle: .alert)
                    
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                
                self.tabBarController?.selectedIndex = 2
                _ = self.navigationController?.popToRootViewController(animated: true)

                alertController.dismiss(animated: true, completion: nil)
                })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
                }
                else
                {
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: "Your Payment not successful please try again.", view: self)
                }
            }
        }) { (error) in
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
