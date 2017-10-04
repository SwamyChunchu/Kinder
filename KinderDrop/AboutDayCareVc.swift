//
//  AboutDayCareVc.swift
//  KinderDrop
//
//  Created by amit on 4/13/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import LCBannerView
import SDWebImage

import GoogleMaps
import CoreLocation

class AboutDayCareVc: UIViewController,LCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GMSMapViewDelegate,TPFloatRatingViewDelegate,UITextViewDelegate

{
    
    var reviewCell: ReviewTableCell!
    var availableCell: AvailabelTableCell!
    
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    
    var imageView = UIView()
    var zoomButtin = UIButton()
    var aboutButton = UIButton()
    var mapButton = UIButton()
    var reviewButton = UIButton()
    var availabiltyButton = UIButton()
    
    var bookNowButtonAbout = UIButton()
    var addReviewButtonAbout = UIButton()
    
    var lineLabel = UILabel()
    var detailView = UIView()
    var buttonView = UIView()
    
    var aboutView = UIView()
    var aboutBackGrndView = UIView()
    let nameLblAbt = UILabel()
    let addressLblAbt = UILabel()
    let availablLblAbt = UILabel()
    let priceLblAbt = UILabel()
    let disriptHeaderLbl = UILabel()
    let breafDiscrptnLbl = UILabel()
    let facilityTextLbl = UILabel()
    let noRvwLbl = UILabel()
    let discrptView = UIView()
    let facilityHedderLbl = UILabel()
    
    
    var scrollViewAbout = UIScrollView()
    var mapBackGrndView = UIView()
    var reviewView = UIView()
    var availibilityView = UIView()
    
    var reviewTableView = UITableView()
    var availableTableView = UITableView()
    
//    var currentLatitude = Double()
//    var currentLongitude = Double()
    
    var userID = String()
    var daycareID = String()
    
    var dataDic = NSDictionary()
    var slotArray = NSArray()
    var dateArray = NSArray()
    
    
    var reviewArray = NSArray()
    var imagesArray = NSArray()
    
    let popUpView = UIScrollView()
    let textView = UITextView()
    var selectedStars = String()
    let alertView = UIView()
    let addratingView = TPFloatRatingView()
    let reviewLabel = UILabel()
    let cancelBtn = UIButton()
    let reviewBtn = UIButton()
    
    @IBOutlet weak var displayName: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.tabBarController?.tabBar.isHidden = true
      userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
      self.imagesArray = ["http://think360.in/kindr/api/uploads/uploadedPic-327328288.452.jpeg"]
        
      self.myView()
      self.dayCareDetailAPIMethod()
        
      //self.childInfoAPIMethod()
      perform(#selector(AboutDayCareVc.showMapView), with: nil, afterDelay: 0.5)
 }
    func showMapView()
    {
    }
    
    func dayCareDetailAPIMethod () -> Void
    {
        print(daycareID)
        let baseURL: String  = String(format:"%@get_daycares/",Constants.mainURL)
        let params = "id=\(daycareID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.dataDic = responceDic.object(forKey: "data") as! NSDictionary
                    print(self.dataDic)
                    self.displayName.text! = self.dataDic.object(forKey: "daycare_name") as! String
                    
                    self.imagesArray = ((self.dataDic.object(forKey: "daycareimage") as! NSArray).value(forKey: "image") as? NSArray)!
                    
                    if self.imagesArray.count == 0
                    {
                      self.imagesArray = ["http://think360.in/kindr/api/uploads/uploadedPic-255962348.471.jpeg"]
                    }
                    self.nameLblAbt.text = self.dataDic.object(forKey: "daycare_name") as? String
                    self.addressLblAbt.text = self.dataDic.object(forKey: "address") as? String
                    let availableStr:String = (self.dataDic.object(forKey: "available") as? String)!
                    if availableStr == "1"
                    {
                        self.availablLblAbt.textColor = #colorLiteral(red: 0.09019607843, green: 0.5882352941, blue: 0.1215686275, alpha: 1)
                        self.availablLblAbt.text = "Available"
                    }else{
                        self.availablLblAbt.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        self.availablLblAbt.text  = "Not Available"
                    }
                    let priceStr:String = String(format:"%@",self.dataDic.object(forKey: "price") as! String)
                    if priceStr == ""
                    {
                        self.priceLblAbt.text = "Real Money"
                    }else{
                        self.priceLblAbt.text = priceStr
                    }
                    
                    self.breafDiscrptnLbl.text = self.dataDic.object(forKey: "description") as? String
                    
                    let capableAry:NSArray  = ((self.dataDic.object(forKey: "capability") as! NSArray).value(forKey: "capability") as? NSArray)!
                    let capStr:String = capableAry.componentsJoined(by: "\n")
                    self.facilityTextLbl.text = capStr
                    
                    self.aboutButtonClickedViewMethod()
                    
                    let imagesDataArray = NSMutableArray()
                    for i in 0..<self.imagesArray.count
                    {
                        let image: String = self.imagesArray.object(at: i) as! String
                        //as! NSDictionary).object(forKey: "link") as! String
                        let image1 = image.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        imagesDataArray.add(image1 as Any)
                    }
                    let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), delegate: self, imageURLs: (self.imagesArray as NSArray) as! [Any], placeholderImage:"PlaceHolderImageLoading", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
                    banner?.clipsToBounds = true
                    banner?.contentMode = .scaleAspectFit
                    self.imageView.addSubview(banner!)
                    
                    self.zoomButtin.frame = CGRect(x:0, y:0, width:self.imageView.frame.size.width, height:self.imageView.frame.size.height)
                    self.zoomButtin.backgroundColor = UIColor.clear
                    self.zoomButtin.addTarget(self, action: #selector(AboutDayCareVc.zoomButtonAction(_:)), for: UIControlEvents.touchUpInside)
                    banner?.addSubview(self.zoomButtin)
                    
                    
                    self.reviewArray = (self.dataDic.object(forKey: "Review") as? NSArray)!
                    self.reviewTableView.reloadData()

                    if self.reviewArray.count == 0
                    {
                        self.noRvwLbl.isHidden = false
                        self.reviewTableView.isHidden = true
                    }else{
                        self.reviewTableView.isHidden = false
                        self.noRvwLbl.isHidden = true
                    }
                    
                    self.slotArray = (self.dataDic.object(forKey: "slots") as? NSArray)!
                    self.dateArray = (self.slotArray.value(forKey: "slotdate") as? NSArray)!
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
    func myView() -> Void
    {

        imageView.frame = CGRect(x: 0 , y: 64 , width: self.view.frame.size.width , height:self.view.frame.size.height/2-160)
        if UIScreen.main.sizeType == .iPhone5 {
             imageView.frame = CGRect(x: 0 , y: 64 , width: self.view.frame.size.width , height:self.view.frame.size.height/2-100)
        }
        imageView.backgroundColor=UIColor.white
        self.view .addSubview(imageView)

//        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), delegate: self, imageName: "banner", count: 3, timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
//        banner?.clipsToBounds = true
//       imageView.addSubview(banner!)
        
        buttonView.frame = CGRect(x: 0 , y: imageView.frame.origin.y+imageView.frame.size.height , width: self.view.frame.size.width , height:44)
        buttonView.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view .addSubview(buttonView)
        
        aboutButton.frame = CGRect(x:0, y:0, width:self.view.frame.size.width/4-3, height:42)
        aboutButton.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        aboutButton.setTitle("About", for: .normal)
        aboutButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
        aboutButton.setTitleColor(UIColor.black, for: .normal)
        aboutButton.titleLabel?.textAlignment = .center
        aboutButton.addTarget(self, action: #selector(AboutDayCareVc.aboutButtonAction(_:)), for: UIControlEvents.touchUpInside)
        buttonView.addSubview(aboutButton)
        
        mapButton.frame = CGRect(x:aboutButton.frame.origin.x+aboutButton.frame.size.width+2, y:0, width:aboutButton.frame.size.width, height:42)
        mapButton.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mapButton.setTitle("Map", for: .normal)
        mapButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
        mapButton.setTitleColor(UIColor.darkGray, for: .normal)
        mapButton.titleLabel?.textAlignment = .center
        mapButton.addTarget(self, action: #selector(AboutDayCareVc.mapButtonAction(_:)), for: UIControlEvents.touchUpInside)
        buttonView.addSubview(mapButton)
        
        reviewButton.frame = CGRect(x:mapButton.frame.origin.x+mapButton.frame.size.width+2, y:0, width:aboutButton.frame.size.width, height:42)
        reviewButton.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        reviewButton.setTitle("Review", for: .normal)
        reviewButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
        reviewButton.setTitleColor(UIColor.darkGray, for: .normal)
        reviewButton.titleLabel?.textAlignment = .center
        reviewButton.addTarget(self, action: #selector(AboutDayCareVc.reviewButtonAction(_:)), for: UIControlEvents.touchUpInside)
        buttonView.addSubview(reviewButton)
        
        availabiltyButton.frame = CGRect(x:reviewButton.frame.origin.x+reviewButton.frame.size.width+2, y:0, width:aboutButton.frame.size.width, height:42)
        availabiltyButton.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        availabiltyButton.setTitle("Availability", for: .normal)
        availabiltyButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
        availabiltyButton.setTitleColor(UIColor.darkGray, for: .normal)
        availabiltyButton.titleLabel?.textAlignment = .center
        availabiltyButton.addTarget(self, action: #selector(AboutDayCareVc.availabilityButtonAction(_:)), for: UIControlEvents.touchUpInside)
        buttonView.addSubview(availabiltyButton)

        lineLabel.frame = CGRect(x:0, y:44, width:aboutButton.frame.size.width+3, height:2)
        lineLabel.backgroundColor=#colorLiteral(red: 0.07089758664, green: 0.5186603069, blue: 0.5876646042, alpha: 1)
        buttonView.addSubview(lineLabel)
        
        let aboutLabel = UILabel()
        aboutLabel.frame = CGRect(x:mapButton.frame.origin.x-1, y:10, width:2, height:26)
        aboutLabel.backgroundColor=UIColor.lightGray
        buttonView.addSubview(aboutLabel)
        
        let mapLabel = UILabel()
        mapLabel.frame = CGRect(x:reviewButton.frame.origin.x-1, y:10, width:2, height:26)
        mapLabel.backgroundColor=UIColor.lightGray
        buttonView.addSubview(mapLabel)
        
        let reviewLabel = UILabel()
        reviewLabel.frame = CGRect(x:availabiltyButton.frame.origin.x-1, y:10, width:2, height:26)
        reviewLabel.backgroundColor=UIColor.lightGray
        buttonView.addSubview(reviewLabel)
        
        detailView.frame = CGRect(x:0, y:buttonView.frame.origin.y+46, width:self.view.frame.size.width, height:self.view.frame.size.height-(imageView.frame.size.height+buttonView.frame.size.height))
        detailView.backgroundColor=#colorLiteral(red: 0.9410941005, green: 0.9412292838, blue: 0.9410645366, alpha: 1)
        self.view.addSubview(detailView)

        self.aboutButtonClickedViewMethod()

    }
    
    func zoomButtonAction(_ sender: UIButton!)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "BannerViewVC") as? BannerViewVC
        self.navigationController?.pushViewController(myVC!, animated: false)
        myVC?.imagesArrayFul = imagesArray
    }
    
    // MARK: AboutButton Action:
    func aboutButtonAction(_ sender: UIButton!)
    {
        aboutBackGrndView.isHidden=false
        mapBackGrndView.isHidden=true
        reviewView.isHidden=true
        availibilityView.isHidden=true
        
        aboutButton.setTitleColor(UIColor.black, for: .normal)
        mapButton.setTitleColor(UIColor.darkGray, for: .normal)
        reviewButton.setTitleColor(UIColor.darkGray, for: .normal)
        availabiltyButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        lineLabel.frame = CGRect(x:2, y:44, width:aboutButton.frame.size.width, height:2)
        AFWrapperClass.dampingEffect(view: lineLabel)
        
        self.aboutButtonClickedViewMethod()
    }
    
    
    func aboutButtonClickedViewMethod() -> Void
    {
        aboutBackGrndView.frame =  CGRect(x:0, y:0, width:self.view.frame.size.width, height:detailView.frame.size.height)
        self.detailView.addSubview(aboutBackGrndView)
        scrollViewAbout.frame =  CGRect(x:0, y:0, width:self.view.frame.size.width, height:aboutBackGrndView.frame.size.height-105)
        aboutBackGrndView.addSubview(scrollViewAbout)
        
        let aboutSubView = UIView()
        aboutSubView.frame = CGRect(x:0, y:10, width:self.view.frame.size.width, height:120)
        aboutSubView.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        aboutSubView.layer.borderWidth = 0.8
        aboutSubView.layer.borderColor = UIColor.lightGray.cgColor
        scrollViewAbout.addSubview(aboutSubView)
        
        nameLblAbt.frame = CGRect(x:15, y:10, width:self.view.frame.size.width-120, height:50)
        //nameLblAbt.text = dataDic.object(forKey: "daycare_name") as? String
        nameLblAbt.font =  UIFont(name:"Helvetica-Medium", size: 18)
        nameLblAbt.textAlignment = .left
        nameLblAbt.numberOfLines = 2
        nameLblAbt.textColor=UIColor.black
        aboutSubView.addSubview(nameLblAbt)
        
        addressLblAbt.frame = CGRect(x:15, y:60, width:self.view.frame.size.width-120, height:30)
        //addressLblAbt.text = dataDic.object(forKey: "address") as? String
        addressLblAbt.font =  UIFont(name:"Helvetica-Medium", size: 12)
        addressLblAbt.textAlignment = .left
        addressLblAbt.textColor=UIColor.lightGray
        aboutSubView.addSubview(addressLblAbt)
        
        availablLblAbt.frame = CGRect(x:15, y:90, width:self.view.frame.size.width-120, height:30)
        availablLblAbt.font =  UIFont(name:"Helvetica", size: 14)
        
        availablLblAbt.textAlignment = .left
        aboutSubView.addSubview(availablLblAbt)
        
        let startFrmLblAbt = UILabel()
        startFrmLblAbt.frame = CGRect(x:self.view.frame.size.width-120, y:10, width:110, height:30)
        startFrmLblAbt.text = "Starting from"
        startFrmLblAbt.font =  UIFont(name:"Helvetica", size: 12)
        startFrmLblAbt.textAlignment = .right
        startFrmLblAbt.textColor=UIColor.lightGray
        aboutSubView.addSubview(startFrmLblAbt)
        
        priceLblAbt.frame = CGRect(x:self.view.frame.size.width-120, y:40, width:110, height:30)
       // priceLblAbt.text = String(format:"$%@",dataDic.object(forKey: "price") as! String)
        priceLblAbt.font =  UIFont(name:"Helvetica-Bold", size: 16)
        priceLblAbt.textAlignment = .right
        priceLblAbt.textColor=UIColor.black
        aboutSubView.addSubview(priceLblAbt)
        
        let perChildLblAbt = UILabel()
        perChildLblAbt.frame = CGRect(x:self.view.frame.size.width-120, y:70, width:110, height:30)
        perChildLblAbt.text = "Per child per day"
        perChildLblAbt.font =  UIFont(name:"Helvetica", size: 12)
        perChildLblAbt.textAlignment = .right
        perChildLblAbt.textColor=UIColor.lightGray
        aboutSubView.addSubview(perChildLblAbt)
        
       
        disriptHeaderLbl.frame = CGRect(x:15, y:130, width:self.view.frame.size.width-30, height:35)
        disriptHeaderLbl.text = "Brief Description"
        disriptHeaderLbl.font =  UIFont(name:"Helvetica-Medium", size: 20)
        disriptHeaderLbl.textAlignment = .left
        disriptHeaderLbl.textColor=UIColor.black
        scrollViewAbout.addSubview(disriptHeaderLbl)
        
        
        //discrptView.frame = CGRect(x:0, y:170, width:self.view.frame.size.width, height:60)
        
        
        breafDiscrptnLbl.frame = CGRect(x:15, y:10, width:self.view.frame.size.width-30, height:self.view.frame.size.height-20)
        breafDiscrptnLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        //breafDiscrptnLbl.text = dataDic.object(forKey: "description") as? String
        breafDiscrptnLbl.font =  UIFont(name:"Helvetica-Medium", size: 18)
        breafDiscrptnLbl.textAlignment = .left
        breafDiscrptnLbl.textColor=UIColor.lightGray
        breafDiscrptnLbl.numberOfLines = 0
        breafDiscrptnLbl.sizeToFit()
        breafDiscrptnLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        discrptView.addSubview(breafDiscrptnLbl)
        
        discrptView.frame = CGRect(x:0, y:170, width:self.view.frame.size.width, height:breafDiscrptnLbl.frame.size.height+20)
        discrptView.backgroundColor=#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
        discrptView.layer.borderWidth = 0.8
        discrptView.layer.borderColor = UIColor.lightGray.cgColor
        scrollViewAbout.addSubview(discrptView)
        
        facilityHedderLbl.frame = CGRect(x:15, y:discrptView.frame.origin.y+discrptView.frame.size.height, width:self.view.frame.size.width-30, height:35)
        facilityHedderLbl.text = "Facilities"
        facilityHedderLbl.font =  UIFont(name:"Helvetica-Medium", size: 20)
        facilityHedderLbl.textAlignment = .left
        facilityHedderLbl.textColor=UIColor.black
        scrollViewAbout.addSubview(facilityHedderLbl)
        
        facilityTextLbl.frame = CGRect(x:15, y:facilityHedderLbl.frame.origin.y+35, width:self.view.frame.size.width-30, height:self.view.frame.size.height-20)
        facilityTextLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        facilityTextLbl.font =  UIFont(name:"Helvetica-Medium", size: 18)
        facilityTextLbl.textAlignment = .left
        facilityTextLbl.textColor=UIColor.lightGray
        facilityTextLbl.numberOfLines = 0
        facilityTextLbl.sizeToFit()
        facilityTextLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        scrollViewAbout.addSubview(facilityTextLbl)
        
        
        scrollViewAbout.contentSize = CGSize(width:self.view.frame.size.width , height: scrollViewAbout.frame.size.height+breafDiscrptnLbl.frame.size.height+55+facilityTextLbl.frame.size.height)
        
        bookNowButtonAbout.frame = CGRect(x:0, y:aboutBackGrndView.frame.height-105, width:self.view.frame.size.width, height:40)
        bookNowButtonAbout.backgroundColor=#colorLiteral(red: 0.07089758664, green: 0.5186603069, blue: 0.5876646042, alpha: 1)
        bookNowButtonAbout.setTitle("BOOK NOW", for: .normal)
        bookNowButtonAbout.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 14)
        bookNowButtonAbout.setTitleColor(UIColor.white, for: .normal)
        bookNowButtonAbout.titleLabel?.textAlignment = .center
        bookNowButtonAbout.addTarget(self, action: #selector(AboutDayCareVc.bookNowButtonAction(_:)), for: UIControlEvents.touchUpInside)
        aboutBackGrndView.addSubview(bookNowButtonAbout)
    }
    
// MARK: MapButton Action:
    func mapButtonAction(_ sender: UIButton!)
    {
        mapBackGrndView.isHidden=false
        aboutBackGrndView.isHidden=true
        reviewView.isHidden=true
        availibilityView.isHidden=true
        
        aboutButton.setTitleColor(UIColor.darkGray, for: .normal)
        mapButton.setTitleColor(UIColor.black, for: .normal)
        reviewButton.setTitleColor(UIColor.darkGray, for: .normal)
        availabiltyButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        lineLabel.frame = CGRect(x:mapButton.frame.origin.x+2, y:44, width:aboutButton.frame.size.width, height:2)
        AFWrapperClass.dampingEffect(view: lineLabel)
        
        self.mapViewMethod()
    }
    func mapViewMethod() -> Void
    {
    mapBackGrndView.frame =  CGRect(x:0, y:0, width:self.view.frame.size.width, height:detailView.frame.size.height-65)
    mapBackGrndView.backgroundColor=#colorLiteral(red: 0.8534447863, green: 0.8534447863, blue: 0.8534447863, alpha: 1)
        self.detailView.addSubview(mapBackGrndView)
        
    bookNowButtonAbout.frame = CGRect(x:0, y:mapBackGrndView.frame.height-40, width:self.view.frame.size.width, height:40)
    mapBackGrndView.addSubview(bookNowButtonAbout)
        
        let lat: String? = dataDic.object(forKey: "latitude") as? String
        let longi: String? = dataDic.object(forKey: "longitude") as? String
        var doubleLat = Double(lat!)
        var doubleLong = Double(longi!)
        if lat == ""
        {
            doubleLat = 0.0
        }
        if longi == ""
        {
            doubleLong = 0.0
        }
        camera = GMSCameraPosition.camera(withLatitude: doubleLat!, longitude: doubleLong!, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 10, width: mapBackGrndView.frame.size.width, height: mapBackGrndView.frame.size.height-50), camera: camera)
        mapView.delegate = self
        mapBackGrndView.addSubview(mapView)
        
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
        marker.title = dataDic.object(forKey: "address") as? String
        //marker.snippet = "ChandiGarh"
         self.marker.icon = #imageLiteral(resourceName: "Map-icon")
        marker.map = mapView
    }
   
 // MARK: ReviewButton Action:
    func reviewButtonAction(_ sender: UIButton!)
    {
        reviewView.isHidden=false
        mapBackGrndView.isHidden=true
        availibilityView.isHidden=true
        aboutBackGrndView.isHidden=true
        
        aboutButton.setTitleColor(UIColor.darkGray, for: .normal)
        mapButton.setTitleColor(UIColor.darkGray, for: .normal)
        reviewButton.setTitleColor(UIColor.black, for: .normal)
        availabiltyButton.setTitleColor(UIColor.darkGray, for: .normal)
          lineLabel.frame = CGRect(x:reviewButton.frame.origin.x+2, y:44, width:aboutButton.frame.size.width, height:2)
        AFWrapperClass.dampingEffect(view: lineLabel)
        
        self.reViewMethod()
    }
    func reViewMethod() -> Void
    {
        reviewView.frame =  CGRect(x:0, y:0, width:self.view.frame.size.width, height:detailView.frame.size.height)
        reviewView.backgroundColor=#colorLiteral(red: 0.8534447863, green: 0.8534447863, blue: 0.8534447863, alpha: 1)
//        reviewView.layer.borderWidth = 0.8
//        reviewView.layer.borderColor = UIColor.lightGray.cgColor
        self.detailView.addSubview(reviewView)
        
        
        noRvwLbl.frame = CGRect(x:0, y:20, width:self.view.frame.size.width, height:35)
        noRvwLbl.text = "No Reviews"
        noRvwLbl.font =  UIFont(name:"Helvetica_Medium", size: 20)
        noRvwLbl.textAlignment = .center
        noRvwLbl.textColor=UIColor.black
        reviewView.addSubview(noRvwLbl)
        
        reviewTableView.frame = CGRect(x:0, y:10, width:reviewView.frame.size.width, height:reviewView.frame.size.height-115)
        reviewTableView.delegate=self
        reviewTableView.dataSource=self
        reviewTableView.rowHeight = UITableViewAutomaticDimension
        reviewTableView.estimatedRowHeight = 50
        reviewView.addSubview(reviewTableView)
        
        addReviewButtonAbout.frame = CGRect(x:0, y:reviewView.frame.height-105, width:self.view.frame.size.width, height:40)
        addReviewButtonAbout.backgroundColor=#colorLiteral(red: 0.07089758664, green: 0.5186603069, blue: 0.5876646042, alpha: 1)
        addReviewButtonAbout.setTitle("ADD REVIEW", for: .normal)
        addReviewButtonAbout.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 14)
        addReviewButtonAbout.setTitleColor(UIColor.white, for: .normal)
        addReviewButtonAbout.titleLabel?.textAlignment = .center
        addReviewButtonAbout.addTarget(self, action: #selector(AboutDayCareVc.addReviewButtonAction(_:)), for: UIControlEvents.touchUpInside)
        reviewView.addSubview(addReviewButtonAbout)
//        bookNowButtonAbout.frame = CGRect(x:self.view.frame.size.width/2+1, y:reviewView.frame.height-105, width:self.view.frame.size.width/2-1, height:40)
//        reviewView.addSubview(bookNowButtonAbout)
        
            }
    
 // MARK: AvailabilityButton Action:
    func availabilityButtonAction(_ sender: UIButton!)
    {
        availibilityView.isHidden=false
        mapBackGrndView.isHidden=true
        reviewView.isHidden=true
        aboutBackGrndView.isHidden=true
        
        aboutButton.setTitleColor(UIColor.darkGray, for: .normal)
        mapButton.setTitleColor(UIColor.darkGray, for: .normal)
        reviewButton.setTitleColor(UIColor.darkGray, for: .normal)
        availabiltyButton.setTitleColor(UIColor.black, for: .normal)
        
        lineLabel.frame = CGRect(x:availabiltyButton.frame.origin.x+2, y:44, width:aboutButton.frame.size.width, height:2)
        AFWrapperClass.dampingEffect(view: lineLabel)
        self.availableViewMethod()
    }
    func availableViewMethod() -> Void
    {
        availibilityView.frame =  CGRect(x:0, y:0, width:self.view.frame.size.width, height:detailView.frame.size.height)
//        availibilityView.backgroundColor=UIColor.white
//        availibilityView.layer.borderWidth = 0.8
        availibilityView.layer.borderColor = UIColor.lightGray.cgColor
        self.detailView.addSubview(availibilityView)
        
        let noslotLbl = UILabel()
        noslotLbl.frame = CGRect(x:0, y:20, width:self.view.frame.size.width, height:35)
        noslotLbl.text = "No Slots Available"
        noslotLbl.font =  UIFont(name:"Helvetica_Medium", size: 20)
        noslotLbl.textAlignment = .center
        noslotLbl.textColor=UIColor.black
        availibilityView.addSubview(noslotLbl)
        
        let dateLbl = UILabel()
        dateLbl.frame = CGRect(x:10, y:10, width:self.view.frame.size.width, height:35)
        dateLbl.text = "Date"
        dateLbl.font =  UIFont(name:"Helvetica_Medium", size: 18)
        dateLbl.textAlignment = .left
        dateLbl.textColor=UIColor.black
        availibilityView.addSubview(dateLbl)
        
        let slotLbl = UILabel()
        slotLbl.frame = CGRect(x:self.view.frame.size.width/2-30, y:10, width:60, height:35)
        slotLbl.text = "Slots"
        slotLbl.font =  UIFont(name:"Helvetica_Medium", size: 18)
        slotLbl.textAlignment = .center
        slotLbl.textColor=UIColor.black
        availibilityView.addSubview(slotLbl)
        
        availableTableView.frame = CGRect(x:0, y:45, width:availibilityView.frame.size.width, height:availibilityView.frame.size.height-60)
        availableTableView.delegate=self
        availableTableView.dataSource=self
        availableTableView.estimatedRowHeight = 50
        availableTableView.layer.borderWidth = 0.8
        availableTableView.layer.borderColor = UIColor.lightGray.cgColor
        availibilityView.addSubview(availableTableView)
        
        if self.slotArray.count == 0
        {
            noslotLbl.isHidden = false
            dateLbl.isHidden = true
            slotLbl.isHidden = true
          availableTableView.isHidden = true
            
        }else{
            noslotLbl.isHidden = true
            dateLbl.isHidden = false
            slotLbl.isHidden = false
          availableTableView.isHidden = false
          availableTableView.reloadData()
        }
        
    }
   //MARK: TableView Delegates and Datasource:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.reviewTableView  {
             return UITableViewAutomaticDimension
        }
        else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.reviewTableView {
              return self.reviewArray.count
        }else
        {
        return self.slotArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == self.reviewTableView {
            
            let identifier = "ReviewTableCell"
            reviewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReviewTableCell
            
            if reviewCell == nil
            {
                tableView.register(UINib(nibName: "ReviewTableCell", bundle: nil), forCellReuseIdentifier: identifier)
                reviewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReviewTableCell
            }
            
            self.reviewTableView.separatorStyle = .none
            reviewCell.selectionStyle = UITableViewCellSelectionStyle.none
            
//            reviewCell.ratingView.emptySelectedImage = UIImage(named: "rating-star-off@2x.png")
//            reviewCell.ratingView.fullSelectedImage = UIImage(named: "rating-star-on@2x.png")
//            reviewCell.ratingView.contentMode = UIViewContentMode.scaleAspectFill
//            reviewCell.ratingView.maxRating = 5
//            reviewCell.ratingView.minRating = 1
//            reviewCell.ratingView.editable=false
//            reviewCell.ratingView.rating = CGFloat(floatValue!)
            
            var starStr:String = (self.reviewArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "stars") as! String
            
             starStr = String(starStr.replacingOccurrences(of: ".0", with: ""))
            
            if starStr == "1"
            {
                reviewCell.ratingLabel.text = starStr
                reviewCell.backView.backgroundColor = #colorLiteral(red: 1, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
            }
             else if starStr == "2"
            {
                reviewCell.ratingLabel.text = starStr
                reviewCell.backView.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
            }
            else if starStr == "3"
            {
                reviewCell.ratingLabel.text = starStr
                reviewCell.backView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
            }
            else if starStr == "4"
            {
                reviewCell.ratingLabel.text = starStr
                reviewCell.backView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
            }
            else if starStr == "5" 
            {
                reviewCell.ratingLabel.text = starStr
                reviewCell.backView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
            }
            
            let reviewTextStr:String = (self.reviewArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "review_text") as! String
            if reviewTextStr == "" {
                reviewCell.textRvwLabel.text! = " "
            }else
            {
            reviewCell.textRvwLabel.text! = reviewTextStr
            }
            reviewCell.nameLabelRvw.text! = (self.reviewArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as! String
            reviewCell.dateLblRvw.text! = (self.reviewArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "reviewdate") as! String
            
            
//            let imageURL: String = (self.reviewArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "profilepic") as! String
//            let url = NSURL(string:imageURL)
//            reviewCell.reviewImageView.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "PlaceHolderImageLoading"))
            
          return reviewCell
       }else{
            let identifier = "AvailabelTableCell"
            availableCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AvailabelTableCell
            
            if availableCell == nil
            {
                tableView.register(UINib(nibName: "AvailabelTableCell", bundle: nil), forCellReuseIdentifier: identifier)
                availableCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AvailabelTableCell
            }
            
            self.availableTableView.separatorStyle = .none
            availableCell.selectionStyle = UITableViewCellSelectionStyle.none
        
            availableCell.dateLabel.text! = (self.slotArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "slotdate") as! String
            availableCell.slotLabel.text! = (self.slotArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "number_seats") as! String
            
            availableCell.bookNowAvailBtn.tag = indexPath.row
            availableCell.bookNowAvailBtn.addTarget(self, action: #selector(AboutDayCareVc.availableBookButtonAction(_:)), for: UIControlEvents.touchUpInside)
    
            return availableCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    // MARK: Book Now AvailabelButton Action:
    func availableBookButtonAction(_ sender: UIButton!) {
        let buttonPosition = sender.convert(sender.bounds.origin, to: availableTableView)
        let indexPath: IndexPath? = availableTableView.indexPathForRow(at: buttonPosition)
        availableCell = availableTableView.cellForRow(at: indexPath!) as! AvailabelTableCell!
        
        if sender.tag == indexPath?.row
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildBookingVC") as? ChildBookingVC
            self.navigationController?.pushViewController(myVC!, animated: true)
            myVC?.slotOneLblStr = "N/A"
            myVC?.slottwoLblStr = "N/A"
            myVC?.slotThreeLblStr = "N/A"
            myVC?.slotBkArray = slotArray
            myVC?.dayCareID = (self.slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "daycareid") as! String
            myVC?.dateString = (self.slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "slotdate") as! String
            
            let getSlotTypeOne:String = (slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "Slot_type_arr1") as! String
            let getSlotTypeTwo:String = (slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "Slot_type_arr2") as! String
            let getSlotTypeThree:String = (slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "Slot_type_arr3") as! String
            
            let One:String = (slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "slotamount_arr1") as! String
            let Two:String = (slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "slotamount_arr2") as! String
            let Three:String = (slotArray.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "slotamount_arr3") as! String
            
            
            //1
            if getSlotTypeOne == "1"
            {
                myVC?.slotTypeOne = "1"
                myVC?.amountOne = One
                myVC?.slotOneLblStr =  "Available"
            }
            else if getSlotTypeOne == "2"
            {
                myVC?.slotTypeTwo = "2"
                myVC?.amountTwo = One
                myVC?.slottwoLblStr =  "Available"
            }
            else if getSlotTypeOne == "3"
            {
                myVC?.slotTypeThree = "3"
                myVC?.amountThree = One
                myVC?.slotThreeLblStr = "Available"
            }
            
            //2
            if getSlotTypeTwo == "1"
            {
                myVC?.slotTypeOne = "1"
                myVC?.amountOne = Two
                myVC?.slotOneLblStr = "Available"
            }
            else if getSlotTypeTwo == "2" {
                myVC?.slotTypeTwo = "2"
                myVC?.amountTwo = Two
                myVC?.slottwoLblStr = "Available"
            }
            else if getSlotTypeTwo == "3" {
                myVC?.slotTypeThree = "3"
                myVC?.amountThree = Two
                myVC?.slotThreeLblStr = "Available"
            }
            
            //3
            if getSlotTypeThree == "1"
            {
                myVC?.slotTypeOne = "1"
                myVC?.amountOne = Three
                myVC?.slotOneLblStr = "Available"
            }
            else if getSlotTypeThree == "2" {
                myVC?.slotTypeTwo = "2"
                myVC?.amountTwo = Three
                myVC?.slottwoLblStr = "Available"
            }
            else if getSlotTypeThree == "3" {
                myVC?.slotTypeThree = "3"
                myVC?.amountThree = Three
                myVC?.slotThreeLblStr = "Available"
            }
           
        }
    }
    
    func bookNowButtonAction(_ sender: UIButton!) {
        if self.slotArray.count == 0
        {
          AFWrapperClass.alert(Constants.applicationName, message: "No Slots Available", view: self)  
        }else
        {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildBookingVC") as? ChildBookingVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        myVC?.dayCareID  = self.dataDic.object(forKey: "daycare_id") as! String
        myVC?.slotBkArray = slotArray
//        myVC?.priceStr = self.dataDic.object(forKey: "price") as! String
//        myVC?.slotTypeString = "1"
//        myVC?.slotDatesAry = self.dateArray
//        myVC?.dateString = ""
        }
        
       
    }
    
 // MARK: Add Review Button Action:
    func addReviewButtonAction(_ sender: UIButton!) {
        self.reviewViewMethod()
    }
    
    @objc private func reviewViewMethod () -> Void
    {
        popUpView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view .addSubview(popUpView)
        
        alertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-120, width:self.view.frame.size.width-60, height:240)
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 5
        popUpView.addSubview(alertView)
        
                addratingView.frame = CGRect(x:alertView.frame.size.width/2-70, y:5, width:140, height:50)
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
        cancelBtn.addTarget(self, action: #selector(AboutDayCareVc.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelBtn.layer.cornerRadius = 4
        alertView.addSubview(cancelBtn)

        
        reviewBtn.frame = CGRect(x:alertView.frame.size.width/2+10, y:textView.frame.origin.y+130, width:alertView.frame.size.width/2-20, height:35)
        reviewBtn.backgroundColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        reviewBtn.setTitle("OK", for: .normal)
        reviewBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 15)
        reviewBtn.setTitleColor(UIColor.white, for: .normal)
        reviewBtn.titleLabel?.textAlignment = .left
        reviewBtn.addTarget(self, action: #selector(AboutDayCareVc.OKButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        let params = "userid=\(userID)&daycareid=\(daycareID)&stars=\(selectedStars)&review_text=\(textView.text!)"
        //AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
            AFWrapperClass.svprogressHudDismiss(view: self)
            let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "message") as! String) == "succesfully Review"
                {
                    //let Dic:NSDictionary  = responceDic.object(forKey: "data") as! NSDictionary
                    self.popUpView.removeFromSuperview()
                    AFWrapperClass.alert(Constants.applicationName, message: "Your review successfully added.", view: self)
                    self.dayCareDetailAPIMethod()
                    self.reviewTableView.reloadData()
                }
                else if (responceDic.object(forKey: "message") as! String) == "Update Successfully"
                {
                    self.dayCareDetailAPIMethod()
                    self.reviewTableView.reloadData()
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
     _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIScreen {
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
    }
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}

