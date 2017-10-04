//
//  ChildBookingVC.swift
//  KinderDrop
//
//  Created by think360 on 14/06/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
class ChildBookingTVCell: UITableViewCell {
    
    @IBOutlet weak var selectChildButton: UIButton!
    @IBOutlet weak var childNameLbl: UILabel!
    @IBOutlet weak var imageViewChild: UIImageView!
    @IBOutlet weak var buttonSelectImage: UIImageView!
}
class ChildBookingVC: UIViewController,UITableViewDelegate,UITableViewDataSource,WWCalendarTimeSelectorProtocol {
    
    var cell: ChildBookingTVCell!
    var slotCell: SlotDatesTVcell!
    @IBOutlet weak var bookingDateTF: ACFloatingTextfield!
    @IBOutlet weak var fullDayButton: UIButton!
    @IBOutlet weak var halfDayButton: UIButton!
    @IBOutlet weak var secondHalfButton: UIButton!
    @IBOutlet weak var dollerLabel: UILabel!
    @IBOutlet weak var payAndBookButton: UIButton!
    @IBOutlet weak var ChildListTV: UITableView!
    @IBOutlet weak var childListTVhightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var slotOneLbl: UILabel!
    @IBOutlet weak var slottwoLbl: UILabel!
    @IBOutlet weak var slotThreeLbl: UILabel!
    
    var userID = String()
    var dataChildAry = NSArray()
    var ChildIDArray = NSMutableArray()
    var selectionChildArray = NSMutableArray()
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    //var slotDatesAry = NSArray()
    
    var slotTypeString = String()
    var dayCareID = String()
    var priceStr = String()
    var totalStr = String()
    var slotBkArray = NSArray()
    
    let popUpView = UIScrollView()
    let alertView = UIView()
    var slotTableView = UITableView()
    var crossBtn = UIButton()
    
    var  slotTypeOne = String()
    var  slotTypeTwo = String()
    var  slotTypeThree = String()
    
    var  amountOne = String()
    var  amountTwo = String()
    var  amountThree = String()
    
    var  dateString = String()
    var slotOneLblStr = String()
    var slottwoLblStr = String()
    var slotThreeLblStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
        self.tabBarController?.tabBar.isHidden = true
        
//        slotTypeOne = ""
//        slotTypeTwo  = ""
//        slotTypeThree  = ""
//        amountOne  = ""
//        amountTwo  = ""
//        amountThree  = ""
        slotOneLbl.text! = slotOneLblStr
        slottwoLbl.text! = slottwoLblStr
        slotThreeLbl.text! = slotThreeLblStr
        
        priceStr = "0"
        priceStr = priceStr.replacingOccurrences(of: " ", with: "")
        amountCalculation()
       self.buttonImageMethod()
        self.bookingDateTF.text! = dateString
        
//        if slotOneLblStr == "Available"
//        {
//            fullDayButton.setTitleColor(UIColor.black, for: .normal)
//        }
//        if slottwoLblStr == "Available"
//        {
//            halfDayButton.setTitleColor(UIColor.black, for: .normal)
//        }
//        if slotThreeLblStr == "Available"
//        {
//           secondHalfButton.setTitleColor(UIColor.black, for: .normal)
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.childInfoAPIMethod()
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
                        self.selectionChildArray.add(false)
                    }
                    self.childListTVhightConstarint.constant = 46 * CGFloat(self.dataChildAry.count)
                    self.ChildListTV.reloadData()
                }
                else
                {
                    if self.dataChildAry.count == 0
                    {
                        self.childListTVhightConstarint.constant = 0
                    }
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
        if tableView == ChildListTV
        {
            return dataChildAry.count
        }else{
            return slotBkArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == ChildListTV
        {
            return 46
        }else{
            return 35
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        
        if tableView == ChildListTV
        {
            let identifier = "ChildBookingTVCell"
            cell  = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChildBookingTVCell
            
            if cell == nil
            {
                tableView.register(UINib(nibName: "ChildBookingTVCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChildBookingTVCell
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let link:String = (dataChildAry.object(at: indexPath.row) as! NSDictionary).object(forKey: "profilepic") as! String
            cell.imageViewChild.setShowActivityIndicator(true)
            cell.imageViewChild.setIndicatorStyle(.gray)
            cell.imageViewChild.sd_setImage(with: NSURL(string:link) as URL!, placeholderImage: #imageLiteral(resourceName: "profilePlaceHolder"))
            cell.childNameLbl.text! = ((dataChildAry.object(at: indexPath.row) as! NSDictionary).object(forKey: "child_name") as? String)!
            
            cell.selectChildButton.tag = indexPath.row
            cell.selectChildButton.addTarget(self, action: #selector(ChildBookingVC.bookButtonAction(_:)), for: UIControlEvents.touchUpInside)
            cell.selectChildButton.isSelected = true
            
            let check = selectionChildArray.object(at: indexPath.row) as! Bool
            
            if check == true {
                cell.buttonSelectImage.image = #imageLiteral(resourceName: "CheckBokRight")
            }else
            {
                cell.buttonSelectImage.image = #imageLiteral(resourceName: "UnChkSquare")
            }
            
            return cell
        }
        
        else{
            
            let identifier = "SlotDatesTVcell"
            slotCell  = tableView.dequeueReusableCell(withIdentifier: identifier) as? SlotDatesTVcell
            if slotCell == nil
            {
                tableView.register(UINib(nibName: "SlotDatesTVcell", bundle: nil), forCellReuseIdentifier: identifier)
                slotCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SlotDatesTVcell
            }

            slotCell.datelabel.text! = (self.slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "slotdate") as! String
            
            return slotCell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     if tableView == ChildListTV
     {
        let check = selectionChildArray.object(at: indexPath.row) as! Bool
        selectionChildArray.replaceObject(at: indexPath.row, with: !check)
        
        ChildListTV.reloadData()
        amountCalculation()
        
     }else
     {
        slotTypeOne = ""
        slotTypeTwo  = ""
        slotTypeThree  = ""
        amountOne  = ""
        amountTwo  = ""
        amountThree  = ""
        slotOneLbl.text! = "N/A"
        slottwoLbl.text! = "N/A"
        slotThreeLbl.text! = "N/A"
        self.buttonImageMethod()
       // self.buttonImageMethodDarkGrayColor()
        
        popUpView.isHidden = true
        
        self.bookingDateTF.text! = (slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "slotdate") as! String
        
      let getSlotTypeOne = (slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "Slot_type_arr1") as! String
       let getSlotTypeTwo = (slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "Slot_type_arr2") as! String
       let getSlotTypeThree = (slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "Slot_type_arr3") as! String
        
        let One = (slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "slotamount_arr1") as! String
        let Two = (slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "slotamount_arr2") as! String
       let Three = (slotBkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "slotamount_arr3") as! String
        //1
        if getSlotTypeOne == "1"
        {
            self.slotTypeOne = "1"
            amountOne = One
           // slotOneLbl.text! =  String(format:"$%@",One)
            slotOneLbl.text! = "Available"
            //slotOneLbl.textColor = UIColor.green
            fullDayButton.setTitleColor(UIColor.black, for: .normal)
        }
        else if getSlotTypeOne == "2"{
            self.slotTypeTwo = "2"
            amountTwo = One
           // slottwoLbl.text! =  String(format:"$%@",One)
            slottwoLbl.text! = "Available"
            halfDayButton.setTitleColor(UIColor.black, for: .normal)
        }
        else if getSlotTypeOne == "3"{
            self.slotTypeThree = "3"
            amountThree = One
          //  slotThreeLbl.text! = String(format:"$%@",One)
            slotThreeLbl.text! = "Available"
            secondHalfButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        //2
        if getSlotTypeTwo == "1"
        {
            self.slotTypeOne = "1"
            amountOne = Two
           // slotOneLbl.text! = String(format:"$%@",Two)
            slotOneLbl.text! = "Available"
            fullDayButton.setTitleColor(UIColor.black, for: .normal)
        }
        else if getSlotTypeTwo == "2" {
            self.slotTypeTwo = "2"
            amountTwo = Two
           // slottwoLbl.text! = String(format:"$%@",Two)
            slottwoLbl.text! = "Available"
            halfDayButton.setTitleColor(UIColor.black, for: .normal)
        }
        else if getSlotTypeTwo == "3" {
            self.slotTypeThree = "3"
            amountThree = Two
           // slotThreeLbl.text! = String(format:"$%@",Two)
            slotThreeLbl.text! = "Available"
            secondHalfButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        //3
        if getSlotTypeThree == "1"
        {
            self.slotTypeOne = "1"
            amountOne = Three
           // slotOneLbl.text! = String(format:"$%@",Three)
            slotOneLbl.text! = "Available"
            fullDayButton.setTitleColor(UIColor.black, for: .normal)
                                }
        else if getSlotTypeThree == "2"{
            self.slotTypeTwo = "2"
            amountTwo = Three
           // slottwoLbl.text! = String(format:"$%@",Three)
            slottwoLbl.text! = "Available"
            halfDayButton.setTitleColor(UIColor.black, for: .normal)
            }
        else if getSlotTypeThree == "3" {
            self.slotTypeThree = "3"
            amountThree = Three
            //slotThreeLbl.text! = String(format:"$%@",Three)
            slotThreeLbl.text! = "Available"
            secondHalfButton.setTitleColor(UIColor.black, for: .normal)
        }
        priceStr = "0"
        amountCalculation()
        }
 
    }
    
    
    
    
    
    // MARK: Book Button Action:
    func bookButtonAction(_ sender: UIButton!) {
        let check = selectionChildArray.object(at: sender.tag) as! Bool
        
        selectionChildArray.replaceObject(at: sender.tag, with: !check)
        ChildListTV.reloadData()
        amountCalculation()
    }
    
   // MARK: Total amount Calculation:
    func amountCalculation() -> Void {
        var count = NSInteger()
        for item in 0..<selectionChildArray.count {
            let check = selectionChildArray.object(at: item) as! Bool
            if check == true {
                count = count+1
            }
        }

        let total = count * Int(priceStr)!
        totalStr = String(total)
        if totalStr == "0" {
            self.dollerLabel.isHidden = true
        }else{
            self.dollerLabel.isHidden = false
            self.dollerLabel.text! = String(format:"$%@",totalStr)
        }
    }
    
// MARK: Booking type button Actions:
    @IBAction func fullDayButtonAction(_ sender: Any) {
        
        if self.bookingDateTF.text!.isEmpty
        {
          AFWrapperClass.alert(Constants.applicationName, message: "Please select Date", view: self)
        }else{
           
            if slotTypeOne == ""
            {
              AFWrapperClass.alert(Constants.applicationName, message: "No Slots Avilable", view: self)
            }else{
                self.buttonImageMethod()
        fullDayButton.setTitleColor(UIColor.white, for: .normal)
        fullDayButton.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
    
            self.slotTypeString = slotTypeOne
            self.priceStr = amountOne
            amountCalculation()

            }
        }
    }
    
    @IBAction func firstHlfBtnAction(_ sender: Any) {
        if self.bookingDateTF.text!.isEmpty
        {
            AFWrapperClass.alert(Constants.applicationName, message: "Please select Date", view: self)
        }else{
            if slotTypeTwo == ""
            {
                AFWrapperClass.alert(Constants.applicationName, message: "No Slots Avilable", view: self)
            }else{
                self.buttonImageMethod()
                halfDayButton.setTitleColor(UIColor.white, for: .normal)
                halfDayButton.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
                
                self.slotTypeString = slotTypeTwo
                self.priceStr = amountTwo
                amountCalculation()
              
            }
        
        }
    }
    
    @IBAction func secondHlfBtnAction(_ sender: Any) {
        if self.bookingDateTF.text!.isEmpty
        {
            AFWrapperClass.alert(Constants.applicationName, message: "Please select Date", view: self)
        }else{
            if slotTypeThree == ""
            {
                AFWrapperClass.alert(Constants.applicationName, message: "No Slots Avilable", view: self)
            }else{
                self.buttonImageMethod()
                secondHalfButton.setTitleColor(UIColor.white, for: .normal)
                secondHalfButton.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
                
                self.slotTypeString = slotTypeThree
                self.priceStr = amountThree
                amountCalculation()

            }
        }
    }
    
    func buttonImageMethod()
    {
        fullDayButton.setTitleColor(UIColor.black, for: .normal)
        fullDayButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        halfDayButton.setTitleColor(UIColor.black, for: .normal)
        halfDayButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        secondHalfButton.setTitleColor(UIColor.black, for: .normal)
        secondHalfButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    func buttonImageMethodDarkGrayColor()
    {
        fullDayButton.setTitleColor(UIColor.darkGray, for: .normal)
        fullDayButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        halfDayButton.setTitleColor(UIColor.darkGray, for: .normal)
        halfDayButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        secondHalfButton.setTitleColor(UIColor.darkGray, for: .normal)
        secondHalfButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

  // MARK: Date Select Button:
    @IBAction func selectDateButton(_ sender: Any) {
        
        if self.slotBkArray.count == 0 {
            AFWrapperClass.alert(Constants.applicationName, message: "No Slots Available", view: self)
        }else{
            let idArray = NSMutableArray()
            for item in 0..<selectionChildArray.count
            {
                let check = selectionChildArray.object(at: item) as! Bool
                if  check == true
                {
                    let childIDs = ((dataChildAry.object(at: item) as! NSDictionary).object(forKey: "child_id") as? String)!
                    idArray.add(childIDs)
                }
            }
            if idArray.count == 0 {
                AFWrapperClass.alert(Constants.applicationName, message: "Please select AnyOne Child", view: self)
            }else{
                self.slotSlectionMethod()
            }
        }
    }
  
    func slotSlectionMethod()
    {
        popUpView.isHidden = false
        popUpView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view .addSubview(popUpView)
        
        crossBtn.frame = CGRect(x:0, y:0, width:popUpView.frame.size.width, height:popUpView.frame.size.height)
        crossBtn.backgroundColor=UIColor.clear
        crossBtn.addTarget(self, action: #selector(ChildBookingVC.crossButtonAction(_:)), for: UIControlEvents.touchUpInside)
        popUpView.addSubview(crossBtn)
        
        alertView.frame = CGRect(x:self.view.frame.size.width/2-140, y:self.view.frame.size.height/2-120, width:280, height:175)
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 5
        crossBtn.addSubview(alertView)
        
        let selectLbl = UILabel()
        selectLbl.frame = CGRect(x:0, y:0, width:self.alertView.frame.size.width, height:35)
        selectLbl.text = "Select Date"
        selectLbl.font =  UIFont(name:"Helvetica-Bold", size: 20)
        selectLbl.textAlignment = .center
        selectLbl.textColor=UIColor.white
        selectLbl.layer.cornerRadius = 5
        selectLbl.clipsToBounds = true
        selectLbl.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        alertView.addSubview(selectLbl)
        
        
        slotTableView.frame = CGRect(x:0, y:35, width:alertView.frame.size.width, height:alertView.frame.size.height-70)
        slotTableView.delegate=self
        slotTableView.dataSource=self
        slotTableView.rowHeight = UITableViewAutomaticDimension
        slotTableView.estimatedRowHeight = 50
        slotTableView.layer.cornerRadius = 5
        alertView.addSubview(slotTableView)
        slotTableView.reloadData()
        
        if slotBkArray.count == 1
        {
            alertView.frame = CGRect(x:self.view.frame.size.width/2-140, y:self.view.frame.size.height/2-120, width:280, height:70)
            slotTableView.frame = CGRect(x:0, y:35, width:alertView.frame.size.width, height:35)
            
        }
        else if slotBkArray.count == 2
        {
            alertView.frame = CGRect(x:self.view.frame.size.width/2-140, y:self.view.frame.size.height/2-120, width:280, height:105)
            slotTableView.frame = CGRect(x:0, y:35, width:alertView.frame.size.width, height:70)
        }
        else if slotBkArray.count == 3
        {
            alertView.frame = CGRect(x:self.view.frame.size.width/2-140, y:self.view.frame.size.height/2-120, width:280, height:140)
            slotTableView.frame = CGRect(x:0, y:35, width:alertView.frame.size.width, height:105)
        }
        else if slotBkArray.count == 4
        {
            alertView.frame = CGRect(x:self.view.frame.size.width/2-140, y:self.view.frame.size.height/2-120, width:280, height:175)
            slotTableView.frame = CGRect(x:0, y:35, width:alertView.frame.size.width, height:140)
        }else{
            alertView.frame = CGRect(x:self.view.frame.size.width/2-140, y:self.view.frame.size.height/2-120, width:280, height:210)
            slotTableView.frame = CGRect(x:0, y:35, width:alertView.frame.size.width, height:alertView.frame.size.height-35)
        }
}
    
    func crossButtonAction(_ sender: Any) {
        popUpView.isHidden = true
    }
    
    // MARK: pay and Bookbutton Action:
    @IBAction func payAndBookBtnAction(_ sender: Any) {
        
        let idArray = NSMutableArray()
        for item in 0..<selectionChildArray.count
        {
            let check = selectionChildArray.object(at: item) as! Bool
            if check == true
            {
                let childIDs = ((dataChildAry.object(at: item) as! NSDictionary).object(forKey: "child_id") as? String)!
                idArray.add(childIDs)
            }
        }
        
        var message = String()
        if (idArray.count == 0)
        {
            message = "Please select AnyOne child"
        }
        else if (bookingDateTF.text?.isEmpty)!
        {
            message = "Please choose booking date"
        }
        else if totalStr == "0"
        {
            message = "Please choose booking type"
        }
        
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "StripePaymentVC") as? StripePaymentVC
            self.navigationController?.pushViewController(myVC!, animated: true)
            myVC?.amountString = totalStr
            myVC?.dayCareID = self.dayCareID
            myVC?.dateString = self.bookingDateTF.text!
            myVC?.slotTypeString = self.slotTypeString
            myVC?.childIDsAry = idArray
        }
   }
    
    @IBAction func addChildrenButton(_ sender: Any) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AddChildVC") as? AddChildVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    
    //    func openCalendarMethod()
    //    {
    //         let selector = WWCalendarTimeSelector.instantiate()
    //        selector.delegate = self
    //        self.present(selector, animated: true, completion: nil)
    //        selector.optionCurrentDate = singleDate
    //        //selector.optionCurrentDates = Set(multipleDates)
    //        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
    //        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
    //        selector.optionStyles.showDateMonth(true)
    //        selector.optionStyles.showMonth(false)
    //        selector.optionStyles.showYear(true)
    //        selector.optionStyles.showTime(false)
    //    }
    //
    //    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
    //        singleDate = date
    //        let dateFormat = date.stringFromFormat("d MMM yyyy")
    //        var check = Bool()
    //        for item in 0..<slotDatesAry.count {
    //           let ddd = slotDatesAry.object(at: item) as! String
    //            if ddd == dateFormat {
    //                check = true
    //                break
    //            }
    //        }
    //        if check == false {
    ////            AFWrapperClass.alert(Constants.applicationName, message: "Slots  not available", view: self)
    //
    //            let alertController = UIAlertController(title: "Kinder Drop", message: "No slots Available on this date. Kindly check Slots Availability", preferredStyle: .alert)
    //            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
    //                _ = self.navigationController?.popViewController(animated: true)
    //                alertController.dismiss(animated: true, completion: nil)
    //            })
    //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert :UIAlertAction!) in
    //                alertController.dismiss(animated: true, completion: nil)
    //            })
    //            alertController.addAction(cancelAction)
    //            alertController.addAction(defaultAction)
    //            present(alertController, animated: true, completion: nil)
    //        }
    //        else{
    //            self.bookingDateTF.text! = dateFormat
    //        }
    //    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
