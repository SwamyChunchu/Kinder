//
//  HistryViewController.swift
//  KinderDrop
//
//  Created by amit on 4/6/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import SDWebImage

class HistryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    var cell: HistryTableVCell!
    
    @IBOutlet weak var histryTableView: UITableView!
  
    var userID = String()
    var dyCreNameAry = NSArray()
    var addressAry = NSArray()
    var idArray = NSArray()
    var imageArray = NSArray()
    var dayCareID = NSArray()
    var boookingIDAry = NSArray()
    
    var  dataArray = NSArray()
    var dataChildAry = NSArray()
    var daycareIDString = String()
    var badgrCountNotf = String()
    
    @IBOutlet weak var badgeCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.histryTableView.delegate=self
        self.histryTableView.dataSource=self
        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
        
         NotificationCenter.default.addObserver(self, selector: #selector(HistryViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    func methodOfReceivedNotification(notification: Notification){
        
        badgrCountNotf = (notification.object as? String)!
        if badgrCountNotf == "0"
        {
            self.badgeCountLabel.isHidden = true
        }else{
            self.badgeCountLabel.isHidden = false
            self.badgeCountLabel.text! = badgrCountNotf
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.badgeCountLabel.isHidden = true
         self.badgeCountAPImethod()
        self.tabBarController?.tabBar.isHidden = false
        self.histryAPIMethod()
    }
    
    func histryAPIMethod () -> Void
    {
        
        let baseURL: String  = String(format: "%@history/",Constants.mainURL)
        let params = "user_id=\(userID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                self.dataArray = responceDic.object(forKey: "data") as! NSArray
                     
                self.dyCreNameAry = self.dataArray.value(forKey: "daycare_name") as! NSArray
                self.addressAry = self.dataArray.value(forKey: "address") as! NSArray
                self.idArray = self.dataArray.value(forKey: "userid") as! NSArray
                self.imageArray = self.dataArray.value(forKey: "daycare_pic") as! NSArray
                self.dayCareID = self.dataArray.value(forKey: "daycareid") as! NSArray
                self.boookingIDAry = self.dataArray.value(forKey: "id") as! NSArray
                    
                self.histryTableView.reloadData()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "No Booking Found", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }

//MARK: TableView Delegates and Datasource:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "HistryTableVCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HistryTableVCell
        if cell == nil
        {
            tableView.register(UINib(nibName: "HistryTableVCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HistryTableVCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.nameLabel.text! = self.dyCreNameAry.object(at: indexPath.row) as! String
        cell.adderssLabel.text! = self.addressAry.object(at: indexPath.row) as! String
        
        let bookingStatusStr:String = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "status") as! String
                if bookingStatusStr == "0"
                {
                    cell.statusLabel.text! = "Confirmed"
                    cell.statusLabel.textColor = #colorLiteral(red: 0.06875123917, green: 0.6068562436, blue: 0.05203864354, alpha: 1)
                }else if bookingStatusStr == "1"
                {
                    cell.statusLabel.text! = "Confirmed"
                    cell.statusLabel.textColor = #colorLiteral(red: 0.06875123917, green: 0.6068562436, blue: 0.05203864354, alpha: 1)
                }
                else if bookingStatusStr == "2"
                {
                    cell.statusLabel.text! = "Cancelled"
                    cell.statusLabel.textColor = #colorLiteral(red: 0.9955382385, green: 0.04946931085, blue: 0, alpha: 1)
                }
                else if bookingStatusStr == "3"
                {
                    cell.statusLabel.text! = "Completed"
                    cell.statusLabel.textColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
                }
        
        
        
        let imageURL: String = self.imageArray.object(at: indexPath.row) as! String
        let url = NSURL(string:imageURL)
        cell.imageVwhistry.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlaceHolderImageLoading"))
        
        cell.bookNowButton.tag = indexPath.row
        cell.bookNowButton.addTarget(self, action: #selector(ListViewController.bookButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        if UI_USER_INTERFACE_IDIOM()  == .phone
//        {
//            return 260
//        }else{
            return 90
 //       }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        daycareIDString = self.dayCareID.object(at: indexPath.row) as! String
        let id:String = self.boookingIDAry.object(at: indexPath.row) as! String
        
        self.bookingDetailsAPIMethod(idStr: id)
    }
    
    func bookingDetailsAPIMethod (idStr:String) -> Void
    {
        
        let baseURL: String  = String(format: "%@view_booking/",Constants.mainURL)
        let params = "booking_tbl_id=\(idStr)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetailsVC") as? BookingDetailsVC
                self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.dataDic = responceDic.object(forKey:"data") as! NSDictionary
                    myVC?.dayCareIDstr = self.daycareIDString
                    myVC?.bookingID = idStr
                    
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Booking Details Not Found.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }

    
    
    
    
// MARK: Book Button Action:
    func bookButtonAction(_ sender: UIButton!) {
        let buttonPosition = sender.convert(sender.bounds.origin, to: histryTableView)
        let tappedID: IndexPath? = histryTableView.indexPathForRow(at: buttonPosition)
        cell = histryTableView.cellForRow(at: tappedID!) as! HistryTableVCell!
        if sender.tag == tappedID?.row
        {
          daycareIDString = self.dayCareID.object(at: (tappedID?.row)!) as! String
          self.dayCareDetailAPIMethod ()
        }
    }

    func dayCareDetailAPIMethod () -> Void
    {
        let baseURL: String  = String(format:"%@get_daycares/",Constants.mainURL)
        let params = "id=\(daycareIDString)"
        
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
  
    
 //MARK: Notification Methods:   
    @IBAction func notificationBottonAction(_ sender: Any) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
   
    func badgeCountAPImethod () -> Void
    {
        let baseURL: String  = String(format: "%@usercount/",Constants.mainURL)
        let  params = "userid=\(userID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    let countStr:String = (dic.object(forKey:"data") as! NSDictionary).object(forKey:"count") as! String
                    if countStr == "0"
                    {
                        self.badgeCountLabel.isHidden = true
                    }else{
                        self.badgeCountLabel.isHidden = false
                        self.badgeCountLabel.text! = countStr
                    }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
