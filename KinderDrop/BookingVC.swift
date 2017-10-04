//
//  BookingVC.swift
//  KinderDrop
//
//  Created by amit on 4/18/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit


class BookingTVCell: UITableViewCell {
    
    @IBOutlet weak var toDateBTN: UIButton!
    @IBOutlet weak var toDateTF: ACFloatingTextfield!
    @IBOutlet weak var fromDateBTN: UIButton!
    @IBOutlet weak var fromDateTF: ACFloatingTextfield!
    @IBOutlet weak var childSelectionBTN: UIButton!
    @IBOutlet weak var amountLBL: UILabel!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var childIMG: UIImageView!
}


class BookingVC: UIViewController,WWCalendarTimeSelectorProtocol,UITableViewDelegate,UITableViewDataSource
{

    
    @IBOutlet weak var childListTVHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var childListTV: UITableView!
    var selectionChildArray = NSMutableArray()
    
    @IBOutlet weak var fullDayBtn: UIButton!
    @IBOutlet weak var firstHlfBtn: UIButton!
    @IBOutlet weak var secondHlfBtn: UIButton!
    
    var finalAmount = NSInteger()
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    @IBOutlet weak var payDollerLabel: UILabel!
    
    var userID = String()
    var dayCareID = String()
    
    var selectionIndex = NSInteger()
    var fromOrToCheck = Bool()
    
    var dataChildAry = NSArray()
    var bookingType = String()
    
    var payFinalAmount = String()
    
    var responseString2 = NSString()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        bookingType = "1"
        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String

         self.tabBarController?.tabBar.isHidden = true
        
        payDollerLabel.text! = "Pay $10"
        finalAmount = 10
        fullDayBtn.backgroundColor=#colorLiteral(red: 0.07089758664, green: 0.5186603069, blue: 0.5876646042, alpha: 1)
        fullDayBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.childInfoAPIMethod()
    }

    @IBAction func fullDayButtonAction(_ sender: UIButton) {
        bookingType = "1"
        finalAmount = 10
        fullDayBtn.backgroundColor=#colorLiteral(red: 0.07089758664, green: 0.5186603069, blue: 0.5876646042, alpha: 1)
        fullDayBtn.setTitleColor(#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1), for: .normal)
        
        firstHlfBtn.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        firstHlfBtn.setTitleColor(#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1), for: .normal)
        
        secondHlfBtn.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        secondHlfBtn.setTitleColor(#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1), for: .normal)
        amountUpdate()
    }

    @IBAction func firstHlfButtonAction(_ sender: UIButton) {
        bookingType = "2"
        finalAmount = 20
        fullDayBtn.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        fullDayBtn.setTitleColor(#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1), for: .normal)
        
        firstHlfBtn.backgroundColor=#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1)
        firstHlfBtn.setTitleColor(#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1), for: .normal)
        
        secondHlfBtn.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        secondHlfBtn.setTitleColor(#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1), for: .normal)
        amountUpdate()
    }
    
    
    @IBAction func secondHlfButtonAction(_ sender: UIButton) {
        bookingType = "3"
        finalAmount = 30
        fullDayBtn.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        fullDayBtn.setTitleColor(#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1), for: .normal)
        
        firstHlfBtn.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        firstHlfBtn.setTitleColor(#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1), for: .normal)
        
        secondHlfBtn.backgroundColor=#colorLiteral(red: 0.1296502948, green: 0.573659718, blue: 0.6346750259, alpha: 1)
        secondHlfBtn.setTitleColor(#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1), for: .normal)
        amountUpdate()
    }
    
    
    
    
    
    
    
    func amountUpdate() -> Void {
        
        var totalAmount = NSInteger()
        
        for item in 0..<dataChildAry.count {
            let from:String = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "fromDate") as! String
            let to:String = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "toDate") as! String
            if from.characters.count != 0 && to.characters.count != 0{
                let fromDate:Date = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "from") as! Date
                
                let toDate:Date = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "to") as! Date
                
                let cou:NSInteger = calicuateDaysBetweenTwoDates(start: fromDate.trimTime(), end: toDate.trimTime())
                
                let total = (cou+1)*finalAmount
                (selectionChildArray.object(at: item) as! NSMutableDictionary).setValue(total, forKey: "amount");
                
                let check = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "selection") as! Bool
                if check == true {
                    totalAmount = total + totalAmount
                }
            }
        }
        payDollerLabel.text! = "Pay $\(totalAmount)"
        payFinalAmount = String(totalAmount)
        childListTV.reloadData()
    }
    
    
    //MARK: Child Information:
    func childInfoAPIMethod() -> Void
    {
        let baseURL: String  = String(format:"%@child_history/",Constants.mainURL)
        let params = "userid=\(userID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.dataChildAry = responceDic.object(forKey: "data") as! NSArray
                    
                    for _ in 0..<self.dataChildAry.count
                    {
                        let dic:NSMutableDictionary = NSMutableDictionary(objects: ["","",false,0,Date(),Date()], forKeys: ["fromDate" as NSCopying,"toDate" as NSCopying,"selection" as NSCopying,"amount" as NSCopying,"from" as NSCopying,"to" as NSCopying])
                        self.selectionChildArray.add(dic)
                    }
                    self.childListTVHeightConstrain.constant = 106 * CGFloat(self.dataChildAry.count)
                    self.amountUpdate()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    //AFWrapperClass.alert(Constants.applicationName, message: "No Daycare Found", view: self)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    // MARK: TableView Delegates:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataChildAry.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        
        let identifier = "BookingTVCell"
        var cell: BookingTVCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BookingTVCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "BookingTVCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BookingTVCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let link:String = (dataChildAry.object(at: indexPath.row) as! NSDictionary).object(forKey: "profilepic") as! String
        
        cell.childIMG.sd_setImage(with: NSURL(string:link) as URL!, placeholderImage: #imageLiteral(resourceName: "profilePlaceHolder"))
        
        cell.childName.text = (dataChildAry.object(at: indexPath.row) as! NSDictionary).object(forKey: "child_name") as? String
        cell.fromDateTF.text = (selectionChildArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "fromDate") as? String
        cell.toDateTF.text = (selectionChildArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "toDate") as? String
        
        let check = (selectionChildArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "selection") as! Bool
        if check == true {
            cell.childSelectionBTN.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: .normal)
        }else
        {
            cell.childSelectionBTN.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: .normal)
        }
        cell.childSelectionBTN.tag = indexPath.row
        cell.fromDateBTN.tag = indexPath.row
        cell.toDateBTN.tag = indexPath.row
        
        cell.childSelectionBTN.addTarget(self, action: #selector(BookingVC.childSelectionBTNTap(sender:)), for: .touchUpInside)
        cell.fromDateBTN.addTarget(self, action: #selector(BookingVC.fromDateBTNTap(sender:)), for: .touchUpInside)
        cell.toDateBTN.addTarget(self, action: #selector(BookingVC.toDateBTNTap(sender:)), for: .touchUpInside)
        let total:NSInteger = (selectionChildArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "amount") as! NSInteger
        if total == 0
        {
            cell.amountLBL.text = ""
        }else
        {
            cell.amountLBL.text = "$ \(total)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    
    // MARK: Child Selection button Actions:
    @objc private func childSelectionBTNTap(sender:UIButton) -> Void
    {
        let check = (selectionChildArray.object(at: sender.tag) as! NSDictionary).object(forKey: "selection") as! Bool
        (selectionChildArray.object(at: sender.tag) as! NSMutableDictionary).setValue(!check, forKey: "selection")
        let str:String = (selectionChildArray.object(at: sender.tag) as! NSDictionary).object(forKey: "fromDate") as! String
        amountUpdate()
        if str.characters.count == 0 {
            AFWrapperClass.alert("Alert!", message: "Select FromDate and ToDate", view: self)
        }
        
    }
    
    // MARK: From and To Date button Actions:
    @objc private func fromDateBTNTap(sender:UIButton) -> Void
    {
        selectionIndex = sender.tag
        fromOrToCheck = true
        openCalendarMethod()
    }
    @objc private func toDateBTNTap(sender:UIButton) -> Void
    {
        selectionIndex = sender.tag
        fromOrToCheck = false
        let str:String = (selectionChildArray.object(at: selectionIndex) as! NSDictionary).object(forKey: "fromDate") as! String
        if str.characters.count != 0 {
            openCalendarMethod()
        }else
        {
            AFWrapperClass.alert("Alert!", message: "Please Select From Date First", view: self)
        }
        
    }

    
    func openCalendarMethod()
    {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        self.present(selector, animated: true, completion: nil)
        selector.optionCurrentDate = singleDate
        //selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(true)
        selector.optionStyles.showTime(false)
    }
    
    // MARK: Calendar Delegates:
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        singleDate = date
        
        if fromOrToCheck == true {
            
            let compare:NSInteger = datesComparison(fromDate: Date(), toDate: date)
            
            if compare == 2 || compare == 3 {
                
               (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue(date.stringFromFormat("d'/'MMMM'/'yyyy'"), forKey: "fromDate")
                (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue(date, forKey: "from")
                let to:String = (selectionChildArray.object(at: selectionIndex) as! NSDictionary).object(forKey: "toDate") as! String
                
                if to.characters.count != 0 {
                   let toDate:Date = (selectionChildArray.object(at: selectionIndex) as! NSDictionary).object(forKey: "to") as! Date
                    
                    let com:NSInteger = datesComparison(fromDate: date, toDate: toDate)
                    if com == 1 {
                        (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue("", forKey: "toDate")
                        (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue(date, forKey: "to");
                        (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue(0, forKey: "amount");
                    }
                }
            }else
            {
                AFWrapperClass.alert("Alert!", message: "Please Select current Date or future Dates only", view: self)
            }

        }else
        {
            let fromDate:Date = (selectionChildArray.object(at: selectionIndex) as! NSDictionary).object(forKey: "from") as! Date
            let compare:NSInteger = datesComparison(fromDate: date, toDate: fromDate)
            if compare == 1 {
                (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue(date.stringFromFormat("d'/'MMMM'/'yyyy'"), forKey: "toDate")
                (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue(date, forKey: "to");
                let toDate:Date = (selectionChildArray.object(at: selectionIndex) as! NSDictionary).object(forKey: "to") as! Date
                let cou:NSInteger = calicuateDaysBetweenTwoDates(start: fromDate.trimTime(), end: toDate.trimTime())
                let total = (cou+1)*finalAmount
                (selectionChildArray.object(at: selectionIndex) as! NSMutableDictionary).setValue(total, forKey: "amount");
            }else
            {
                AFWrapperClass.alert("Alert!", message: "Please Select From Date after Dates only", view: self)
            }
        }
        childListTV.reloadData()
        amountUpdate()
    }
    private func calicuateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
//        func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
//            
//            multipleDates = dates
//        }
    
    func datesComparison(fromDate:Date,toDate:Date) -> NSInteger {
        
        if fromDate.trimTime().compare(toDate.trimTime()) == ComparisonResult.orderedDescending
        {
            NSLog("date1 after date2");
            return 1
        } else if fromDate.trimTime().compare(toDate.trimTime()) == ComparisonResult.orderedAscending
        {
            NSLog("date1 before date2");
            return 2
        } else
        {
            NSLog("dates are equal");
            return 3
        }
    }
    
    //MARK: Pay And Book Button Action :
    @IBAction func payandBookBtnAction(_ sender: UIButton) {
        
        let arr = NSMutableArray()
        var cheking = Bool()
        
        for item in 0..<dataChildAry.count {
            
            let check = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "selection") as! Bool
            
            if check == true {
                
                let fromDateStr:String = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "fromDate") as! String;
                let toDateStr:String = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "toDate") as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d'/'MMMM'/'yyyy'"
                dateFormatter.locale = Locale.init(identifier: "en_GB")
                let dateObj = dateFormatter.date(from: fromDateStr)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "d'/'MMMM'/'yyyy'"
                dateFormatter1.locale = Locale.init(identifier: "en_GB")
                let dateObj1 = dateFormatter1.date(from: toDateStr)
                dateFormatter1.dateFormat = "yyyy-MM-dd"
                
                if fromDateStr.characters.count != 0 {
                    if toDateStr.characters.count != 0 {
                        
                        let total:NSInteger = (selectionChildArray.object(at: item) as! NSDictionary).object(forKey: "amount") as! NSInteger
                        
                        let dic:NSDictionary = NSDictionary(objects: [userID,(dataChildAry.object(at: item) as! NSDictionary).object(forKey: "child_id") as! String,dayCareID,dateFormatter.string(from: dateObj!) ,dateFormatter1.string(from: dateObj1!) ,bookingType,total], forKeys: ["userid" as NSCopying,"child_id" as NSCopying,"daycareid" as NSCopying,"booking_date" as NSCopying,"bookingend_date" as NSCopying,"booking_type" as NSCopying,"amount" as String as NSCopying])
                        
                        arr.add(dic)
                    }else
                    {
                        cheking = true
                        AFWrapperClass.alert("Alert!", message: "Select \((dataChildAry.object(at: item) as! NSDictionary).object(forKey: "child_name") as! String) ToDate", view: self)
                        break
                    }
                }else
                {
                    cheking = true
                    AFWrapperClass.alert("Alert!", message: "Select \((dataChildAry.object(at: item) as! NSDictionary).object(forKey: "child_name") as! String) FromDate", view: self)
                    break
                }
            }
        }
        if cheking == false {
            if arr.count != 0 {
                childPaymentAPIMethod(arrayParams: arr)
                
               
            }else
            {
                AFWrapperClass.alert("Alert!", message: "Select Any One Child", view: self)
            }
        }
    }
    
    
    
    //MARK: Child Payment API Method:
    func childPaymentAPIMethod(arrayParams:NSArray) -> Void
    {
    
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: arrayParams, options: [])
        self.responseString2 = String(data: jsonData!, encoding: .utf8)! as NSString
        self.responseString2 = self.responseString2.replacingOccurrences(of: " ", with: "%20") as NSString
        
        let baseURL: String  = String(format:"%@addbooking/",Constants.mainURL)
        let params: String = String(format:"child_data=%@",self.responseString2)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                
                
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
                    let bookIdArray: NSArray = ((responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "booking_id") as! NSArray)

                    //let childIDString :String = bookIdArray.componentsJoined(by: ",")
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "StripePaymentVC") as? StripePaymentVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.amountString = self.payFinalAmount
                   // myVC?.childBookingIds = childIDString
                    
                }else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: "Please try again.", view: self)
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
    }
    

}
