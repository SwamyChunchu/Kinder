//
//  NotificationVC.swift
//  KinderDrop
//
//  Created by amit on 4/18/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,TPFloatRatingViewDelegate,UITextViewDelegate{

    @IBOutlet weak var notificationTableVW: UITableView!
    var cell: notificationTblCell!
    var  dataArray = NSArray()
    var  userID = String()
    var  bookingID = String()
    var  dayCareID = String()
    
    let  popUpView = UIScrollView()
    let  textView = UITextView()
    var  selectedStars = String()
    let  alertView = UIView()
    let  addratingView = TPFloatRatingView()
    let  reviewLabel = UILabel()
    let  cancelBtn = UIButton()
    let  reviewBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
        self.tabBarController?.tabBar.isHidden = true
        
        self.notificationTableVW.delegate=self
        self.notificationTableVW.dataSource=self
       
        self.notificationTableVW.estimatedRowHeight = 100
        self.notificationTableVW.rowHeight = UITableViewAutomaticDimension
        
         self.readUserCountApimethod()
        self.notificationViewApimethod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func notificationViewApimethod () -> Void
    {
        let baseURL: String  = String(format: "%@view_notification/",Constants.mainURL)
        let  params = "userid=\(userID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            DispatchQueue.main.async {
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    self.dataArray = dic.object(forKey: "data") as! NSArray
                    self.notificationTableVW.reloadData()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                     AFWrapperClass.alert(Constants.applicationName, message: "No Notifications", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
   
    func readUserCountApimethod () -> Void
    {
        let baseURL: String  = String(format: "%@readusercount/",Constants.mainURL)
        let  params = "userid=\(userID)"
        //AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
           // AFWrapperClass.svprogressHudDismiss(view: self)
            DispatchQueue.main.async {
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    print(dic)
                }
                else
                {
                AFWrapperClass.svprogressHudDismiss(view: self)
                // AFWrapperClass.alert(Constants.applicationName, message: "No DayCare Found", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    //MARK: TableView Delegates and Datasource:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
       
        let identifier = "notificationTblCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? notificationTblCell
        if cell == nil
        {
            tableView.register(UINib(nibName: "notificationTblCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? notificationTblCell
        }
         cell.selectionStyle = UITableViewCellSelectionStyle.none
        let imageURL: String = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "daycareimage") as! String
        let url = NSURL(string:imageURL)
        cell.imageViewBkng.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlaceHolderImageLoading"))
        cell.nameLbl.text! = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "daycarename") as! String
        
        let bookingStatus:String = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "bookingstatus") as! String
        if bookingStatus == "0"
        {
            cell.bookingStatusLbl.text! = "Booking Confirmed"
            cell.bookingStatusLbl.textColor = #colorLiteral(red: 0.06875123917, green: 0.6068562436, blue: 0.05203864354, alpha: 1)
        }
        else if bookingStatus == "1"
        {
            cell.bookingStatusLbl.text! = "Booking Confirmed"
            cell.bookingStatusLbl.textColor = #colorLiteral(red: 0.06875123917, green: 0.6068562436, blue: 0.05203864354, alpha: 1)
        }
        else if bookingStatus == "2"
        {
            cell.bookingStatusLbl.text! = "Booking Cancelled"
            cell.bookingStatusLbl.textColor = #colorLiteral(red: 0.9955382385, green: 0.04946931085, blue: 0, alpha: 1)
        }
        else if bookingStatus == "3"
        {
            cell.bookingStatusLbl.text! = "Booking Completed"
              cell.bookingStatusLbl.textColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        }
        
        if bookingStatus == "3" {
            
            cell.feedBackbtn.isHidden = false
        }else{
            cell.feedBackbtn.isHidden = true
            cell.feedBtnHightCnstrnt.constant = 0
        }
        
        let reviewStatus:String = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "complete_status") as! String
        
        if reviewStatus == "0" {
            cell.feedBackbtn.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
            cell.feedBackbtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
        }else if reviewStatus == "1"
        {
            cell.feedBackbtn.backgroundColor = UIColor.lightGray
            cell.feedBackbtn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
            cell.feedBackbtn.isUserInteractionEnabled = false
        }
        
        cell.feedBackbtn.tag = indexPath.row
        cell.feedBackbtn.addTarget(self, action: #selector(NotificationVC.feedBackButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
    }
   
    
    
    // MARK: Book Button Action:
    func feedBackButtonAction(_ sender: UIButton!) {
        let buttonPosition = sender.convert(sender.bounds.origin, to: notificationTableVW)
        let tappedID: IndexPath? = notificationTableVW.indexPathForRow(at: buttonPosition)
        cell = notificationTableVW.cellForRow(at: tappedID!) as! notificationTblCell!
        if sender.tag == tappedID?.row
        {
            self.bookingID = (self.dataArray.object(at: (tappedID?.row)!) as! NSDictionary).object(forKey: "booking_id") as! String
            
            self.dayCareID = (self.dataArray.object(at: (tappedID?.row)!) as! NSDictionary).object(forKey: "daycareid") as! String
            self.reviewViewMethod()
        }
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
        
        reviewLabel.frame = CGRect(x:10, y:40, width:100, height:25)
        reviewLabel.text = "Your Review"
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
        cancelBtn.addTarget(self, action: #selector(NotificationVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelBtn.layer.cornerRadius = 4
        alertView.addSubview(cancelBtn)
        
        reviewBtn.frame = CGRect(x:alertView.frame.size.width/2+10, y:textView.frame.origin.y+130, width:alertView.frame.size.width/2-20, height:35)
        reviewBtn.backgroundColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        reviewBtn.setTitle("OK", for: .normal)
        reviewBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 15)
        reviewBtn.setTitleColor(UIColor.white, for: .normal)
        reviewBtn.titleLabel?.textAlignment = .left
        reviewBtn.addTarget(self, action: #selector(NotificationVC.OKButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        let baseURL: String  = String(format:"%@review/",Constants.mainURL)
        let params = "userid=\(userID)&daycareid=\(dayCareID)&stars=\(selectedStars)&review_text=\(textView.text!)&booking_id=\(bookingID)"
        //AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "message") as! String) == "succesfully Review"
                {
                    //let Dic:NSDictionary  = responceDic.object(forKey: "data") as! NSDictionary
                    self.notificationViewApimethod()
                    self.popUpView.removeFromSuperview()
                    AFWrapperClass.alert(Constants.applicationName, message: "Your review successfully added.", view: self)
                }
                else if (responceDic.object(forKey: "message") as! String) == "Update Successfully"
                {
                    self.notificationViewApimethod()
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "NotificationRecived") != nil
        {
            if UserDefaults.standard.value(forKey: "NotificationRecived") as! String == "Received"
            {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
            self.navigationController?.pushViewController(myVC!, animated: true)
                UserDefaults.standard.set("NotReceived", forKey: "NotificationRecived")
            UserDefaults.standard.synchronize()
            }
            else{
                _ = navigationController?.popViewController(animated: true)
            }
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
   }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
