//
//  BookingDetailsVC.swift
//  KinderDrop
//
//  Created by think360 on 23/06/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import LCBannerView
import SDWebImage

class BookingDetailsVC: UIViewController,LCBannerViewDelegate,TPFloatRatingViewDelegate,UITextViewDelegate {

    @IBOutlet weak var bannetImageView: UIView!
    
    @IBOutlet weak var daycareNameLbl: UILabel!
    @IBOutlet weak var childNameLbl: UILabel!
    @IBOutlet weak var bokkingDtLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var slotTypeLbl: UILabel!
    
    var dataDic = NSDictionary()
    var imagesArray = NSArray()
    
    var dayCareIDstr = String()
    var number = String()
    var bookingID = String()
    
    let popUpView = UIScrollView()
    let textView = UITextView()
    var selectedStars = String()
    let alertView = UIView()
    let addratingView = TPFloatRatingView()
    let reviewLabel = UILabel()
    let cancelBtn = UIButton()
    let reviewBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.tabBarController?.tabBar.isHidden = true
        
        let nameStr :String = dataDic.object(forKey: "daycare_name") as! String
        if nameStr == "" {
            daycareNameLbl.text! = "."
        }else{
            daycareNameLbl.text! = nameStr
        }
        
       let childnameStr :String = String(format:"%@",dataDic.object(forKey: "childs_name") as! String)
        if childnameStr == ""
        {
             childNameLbl.text! = " "
        }else{
             childNameLbl.text! = childnameStr
        }
        
        
        bokkingDtLbl.text! = dataDic.object(forKey: "booking_date") as! String
        number = String(format:"%@",dataDic.object(forKey: "contact_no") as! String)
        addressLbl.text! = dataDic.object(forKey: "address") as! String
        
        let bookingStatusStr:String = dataDic.object(forKey: "status") as! String
        if bookingStatusStr == "0"
        {
          statuslabel.text! = "Confirmed"
            statuslabel.textColor = #colorLiteral(red: 0.1676561587, green: 0.7663941062, blue: 0.03169194941, alpha: 1)
        }else if bookingStatusStr == "1"
        {
            statuslabel.text! = "Confirmed"
            statuslabel.textColor = #colorLiteral(red: 0.1676561587, green: 0.7663941062, blue: 0.03169194941, alpha: 1)
        }
        else if bookingStatusStr == "2"
        {
            statuslabel.text! = "Cancelled"
            statuslabel.textColor = #colorLiteral(red: 0.9955382385, green: 0.04946931085, blue: 0, alpha: 1)
        }
        else if bookingStatusStr == "3"
        {
            statuslabel.text! = "Completed"
            statuslabel.textColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        }else{
            statuslabel.text! = ""
            statuslabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if bookingStatusStr == "3"
        {
             self.feedbackBtn.isHidden = false
             let reviewStatusStr:String = dataDic.object(forKey: "complete_status") as! String
            if reviewStatusStr == "0"
            {
            self.feedbackBtn.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
            self.feedbackBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            }else if reviewStatusStr == "1"
            {
            self.feedbackBtn .backgroundColor = UIColor.lightGray
            self.feedbackBtn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
            self.feedbackBtn.isUserInteractionEnabled = false
           }

        }
        else{
            self.feedbackBtn.isHidden = true
        }
        
        
        let bookingTypeStr:String = dataDic.object(forKey: "booking_type") as! String
        if bookingTypeStr == "1"
        {
            slotTypeLbl.text! = "Full Day"
        }else if bookingTypeStr == "2"
        {
            slotTypeLbl.text! = "First Half"
        }
        else if bookingTypeStr == "3"
        {
            slotTypeLbl.text! = "Second Half"
        }
        
        self.imagesArray = dataDic.object(forKey: "daycare_image") as! NSArray
        if self.imagesArray.count == 0
        {
        self.imagesArray = ["http://think360.in/kindr/api/uploads/uploadedPic-327328288.452.jpeg"]
        }
        perform(#selector(BookingDetailsVC.showBannerView), with: nil, afterDelay: 0.5)
        
    }
    func showBannerView()
    {
        
        //        let imagesDataArray = NSMutableArray()
        //        for i in 0..<self.imagesArray.count
        //        {
        //            let image: String = self.imagesArray.object(at: i) as! String
        //            //as! NSDictionary).object(forKey: "link") as! String
        //            let image1 = image.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        //            imagesDataArray.add(image1 as Any)
        //        }
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.bannetImageView.frame.size.width, height: self.bannetImageView.frame.size.height), delegate: self, imageURLs: (self.imagesArray as NSArray) as! [Any], placeholderImage:"PlaceHolderImageLoading", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
        banner?.clipsToBounds = true
        self.bannetImageView.addSubview(banner!)

    }
    
    
    
    @IBAction func callNowBtnAction(_ sender: UIButton) {
        if self.number == ""
        {
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: "Mobile Number Not Avalilable for this", view: self)
        }
        else
        {
            guard let numberOpen = URL(string: "telprompt://" + (self.number as String) ) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(numberOpen)
            } else {
            if let url = URL(string: "tel://"+(self.number)), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
            } else {
                        UIApplication.shared.openURL(url)
                    }
            }
            }
        }
    }
    
    @IBAction func bookAgainBtnAction(_ sender: UIButton) {
        self.dayCareDetailAPIMethod()
    }
    
    func dayCareDetailAPIMethod () -> Void
    {
        let baseURL: String  = String(format:"%@get_daycares/",Constants.mainURL)
        let params = "id=\(dayCareIDstr)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    let dataDic:NSDictionary = responceDic.object(forKey: "data") as! NSDictionary
                    let slotArray:NSArray = (dataDic.object(forKey: "slots") as? NSArray)!
                    // let dateArray:NSArray = (slotArray.value(forKey: "slotdate") as? NSArray)!
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildBookingVC") as? ChildBookingVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.dayCareID  = dataDic.object(forKey: "daycare_id") as! String
                    //            myVC?.priceStr = dataDic.object(forKey: "price") as! String
                    //            myVC?.slotTypeString = "1"
                    myVC?.slotBkArray = slotArray
                    //          myVC?.dateString = ""
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "No Daycare Found", view: self)
                }
            }
            
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    @IBAction func feedbackButtonAction(_ sender: Any) {
    self.reviewViewMethod()
    }
    
    
    // MARK: Add Review Button Action:
    
    @objc private func reviewViewMethod () -> Void
    {
        popUpView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view .addSubview(popUpView)
        
        alertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-120, width:self.view.frame.size.width-60, height:240)
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 5
        popUpView.addSubview(alertView)
        
        addratingView.frame = CGRect(x:alertView.frame.size.width/2-70, y:10, width:140, height:30)
        addratingView.emptySelectedImage = UIImage(named: "rating-star-off@2x.png")
        addratingView.fullSelectedImage = UIImage(named: "rating-star-on@2x.png")
        addratingView.contentMode = UIViewContentMode.scaleAspectFill
        addratingView.maxRating = 5
        addratingView.minRating = 1
        addratingView.rating = 5
        addratingView.editable=true
        addratingView.delegate = self
        alertView.addSubview(addratingView)
        selectedStars = "5"
        
        
        reviewLabel.frame = CGRect(x:10, y:40, width:120, height:25)
        reviewLabel.text = "Your Feedback"
        reviewLabel.font =  UIFont(name:"Helvetica-Medium", size: 16)
        reviewLabel.textAlignment = .left
        reviewLabel.textColor=UIColor.darkGray
        alertView.addSubview(reviewLabel)
        
        textView.frame = CGRect(x:10, y:65, width:alertView.frame.size.width-20, height:120)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.delegate = self
        textView.text = "Enter your review here.."
        textView.textColor = UIColor.lightGray
        reviewLabel.font =  UIFont(name:"Helvetica", size: 12)
        alertView.addSubview(textView)
        
        
        cancelBtn.frame = CGRect(x:10, y:textView.frame.origin.y+130, width:alertView.frame.size.width/2-20, height:35)
        cancelBtn.backgroundColor=#colorLiteral(red: 0.8940391541, green: 0.8941679001, blue: 0.8940109611, alpha: 1)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 15)
        cancelBtn.setTitleColor(UIColor.darkGray, for: .normal)
        cancelBtn.titleLabel?.textAlignment = .left
        cancelBtn.addTarget(self, action: #selector(BookingDetailsVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelBtn.layer.cornerRadius = 4
        alertView.addSubview(cancelBtn)
        
        
        reviewBtn.frame = CGRect(x:alertView.frame.size.width/2+10, y:textView.frame.origin.y+130, width:alertView.frame.size.width/2-20, height:35)
        reviewBtn.backgroundColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        reviewBtn.setTitle("OK", for: .normal)
        reviewBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 15)
        reviewBtn.setTitleColor(UIColor.white, for: .normal)
        reviewBtn.titleLabel?.textAlignment = .left
        reviewBtn.addTarget(self, action: #selector(BookingDetailsVC.OKButtonAction(_:)), for: UIControlEvents.touchUpInside)
        reviewBtn.layer.cornerRadius = 4
        alertView.addSubview(reviewBtn)
    }
    
    @objc private func cancelButtonAction (_ sender : UIButton) -> Void
    {
        popUpView.removeFromSuperview()
        
    }
    @objc private func OKButtonAction (_ sender : UIButton) -> Void
    {
        var message = String()
        if (textView.text?.isEmpty)! || textView.text! == "Enter your review here.."
        {
            message = "Please enter review"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.reviewAPIMethod()
        }
    }
    
    func reviewAPIMethod () -> Void
    {
         let userID :String = dataDic.object(forKey: "userid") as! String
        
        let baseURL: String  = String(format:"%@review/",Constants.mainURL)
        let params = "userid=\(userID)&daycareid=\(dayCareIDstr)&stars=\(selectedStars)&review_text=\(textView.text!)&booking_id=\(bookingID)"
        //AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "message") as! String) == "succesfully Review"
                {
                  
                    
                    self.popUpView.removeFromSuperview()
                    AFWrapperClass.alert(Constants.applicationName, message: "Your review successfully added.", view: self)
                }
                else if (responceDic.object(forKey: "message") as! String) == "Update Successfully"
                {
                    
                    self.popUpView.removeFromSuperview()
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Your review successfully Updated.", view: self)
                }
                else
                {
                    self.popUpView.removeFromSuperview()
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Please try again", view: self)
                }
            }
            
        }) { (error) in
            self.popUpView.removeFromSuperview()
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    
    func floatRatingView(_ ratingView: TPFloatRatingView!, ratingDidChange rating: CGFloat) {
        let integere: Int = Int(rating as CGFloat)
        selectedStars = String(integere)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        alertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-200, width:self.view.frame.size.width-60, height:240)
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        alertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-120, width:self.view.frame.size.width-60, height:240)
        if textView.text.isEmpty {
            textView.text = "Enter your review here.."
            textView.textColor = UIColor.lightGray
        }
    }
    

    
    
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
