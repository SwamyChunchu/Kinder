//
//  MapViewController.swift
//  KinderDrop
//
//  Created by amit on 4/6/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class MapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,WWCalendarTimeSelectorProtocol {

    var searchCell: TSearchableViewCell!
    var Cell: capableCell!
    
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    var currentLocMarker = GMSMarker()
    var gmsCircle = GMSCircle()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
//    var firstLatitude = Double()
//    var firstLongitude = Double()
    var locationManager = CLLocationManager()
    
    var userID = String()
    var id = String()
    var dataArray = NSArray()
    var latitudeArray = NSArray()
    var longitudeArray = NSArray()
    var dyCreNameAry = NSArray()
    
    var  dataArraySearch = NSArray()
    var  mainArraySearch = NSArray()
    
    // filter session outlets:
    @IBOutlet weak var filterButton: UIButton!
    var popUpView = UIView()
    var fiveStrButton = UIButton()
    var fourStrButton = UIButton()
    var threeStrButton = UIButton()
    var dollerOne = UIButton()
    var dollerTwo = UIButton()
    var dollerThree = UIButton()
    let submitBtn = UIButton()
    let clearBtn = UIButton()
    
    let dateHiddenBtn = UIButton()
    let dateRangeVw = UIView()
    let ratingLbl = UILabel()
    let dateRangeLbl = UILabel()
    let ratingVw = UIView()
    let priceingLbl = UILabel()
    let priceVw = UIView()
    let capabilityLbl = UILabel()
    let capabilityVw = UIView()
    
    var fromDateTF = ACFloatingTextfield()
    var toDateTF = ACFloatingTextfield()
    let curntDate = NSDate()
    let nextDayDate = Date()
    
    let filtrView = UIView()
    let filtrImgVw = UIImageView()
    let filterVwLbl = UILabel()
    let dateLineLbl = UILabel()
    
    let toClndrImage = UIImageView()
    let fiveStrLbl = UILabel()
    let fiveStrImage = UIImageView()
    let fourStrLbl = UILabel()
    let fourStrImage = UIImageView()
    let threeStrLbl = UILabel()
    let threeStrImage = UIImageView()
    let dlrOneLbl = UILabel()
    let dlrTwoLbl = UILabel()
    let dlrThreeLbl = UILabel()
    
    
    
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var datenum = Int()
    var ratingStringFltr = String()
    var priceStringFltr = String()
    var capabilityStringFltr = String()
    
    var starFiveStr = String()
    var starFourStr = String()
    var starThreeStr = String()
    
    var fullDayStr = String()
    var firstHlfStr = String()
    var secondHlfStr = String()
    
    var fromDateStr = String()
    var todateFreStr = String()
    
    
    var capabilityTableView = UITableView()
    var capableDataArray = NSArray()
    var selectionChildArray = NSMutableArray()
    
    

    //search city outlets
    var searchPopView = UIView()
    var sarchTFview = UIView()
    var backButtonSearch = UIButton()
    var searchTFpopUp = UITextField()
    var searchImage = UIImageView()
    
//    var searchDoubleLat = Double()
//    var searchDoubleLong = Double()
    
    
    var currenrDateStr = String()
    var DeviceToken=String()
    
    @IBOutlet weak var badgeCountLbl: UILabel!
    @IBOutlet weak var searchMapTF: UITextField!
    var searchTableView = UITableView()
    
    var  latString = String()
    var longtString = String()
    var appDel = AppDelegate()
    
    var badgrCountNotf = String()
    var firstTimeMap = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.shared.delegate as! AppDelegate
    //        currentLatitude = 30.736238
    //        currentLongitude = 76.735191
        
        firstTimeMap = "FristTime"
       userID = UserDefaults.standard.value(forKey: "saveUserID") as! String

        fromDateTF.text! = ""
        toDateTF.text! = ""
        priceStringFltr = ""
        ratingStringFltr = ""
        capabilityStringFltr = ""
        
        self.appDel.searchDoubleLat = 0
        self.appDel.searchDoubleLong = 0
        
       tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.07089758664, green: 0.5186603069, blue: 0.5876646042, alpha: 1)
        searchMapTF.delegate = self
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
//          firstLatitude = (locationManager.location?.coordinate.latitude)!
//          firstLongitude = (locationManager.location?.coordinate.longitude)!
        }
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
        }else{
            let alertController = UIAlertController(title: "Kinder Drop", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                alertController.dismiss(animated: true, completion: nil)
            })
            // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            // alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height-114), camera: camera)
        mapView.delegate = self
        self.mapView.settings.compassButton = true
        //self.mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        
        latString = ""
        longtString = ""
        self.getDayCareAPImethod()
        
        appDel.latitudeSrtAPD = latString
        appDel.longitudeSrtAPD = longtString
        
        self.searchDayCareAPImethod()
        self.capabilityAPImethod()
        print(currentLatitude,currentLongitude)

        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
 func methodOfReceivedNotification(notification: Notification){
    badgrCountNotf = (notification.object as? String)!
    print(badgrCountNotf)
            if badgrCountNotf == "0"
            {
                self.badgeCountLbl.isHidden = true
            }else{
                self.badgeCountLbl.isHidden = false
                self.badgeCountLbl.text! = badgrCountNotf
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         
        
//        if badgrCountNotf == "0"
//        {
//            self.badgeCountLbl.isHidden = true
//        }else{
//            self.badgeCountLbl.isHidden = false
//            self.badgeCountLbl.text! = badgrCountNotf
//        }

        
        starFiveStr = appDel.fiveStarStrAD
        starFourStr = appDel.fourStarStrAD
        starThreeStr = appDel.threeStarStrAD
        fullDayStr = appDel.fullDayStrAD
        firstHlfStr = appDel.firstHlfStrAD
        secondHlfStr = appDel.secondHlfStrAD
        
        self.badgeCountLbl.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.badgeCountAPImethod()
        
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//            currentLatitude = (locationManager.location?.coordinate.latitude)!
//            currentLongitude = (locationManager.location?.coordinate.longitude)!
//            firstLatitude = (locationManager.location?.coordinate.latitude)!
//            firstLongitude = (locationManager.location?.coordinate.longitude)!
//        }
//        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
//        }else{
//            let alertController = UIAlertController(title: "Kinder Drop", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
//                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
//                alertController.dismiss(animated: true, completion: nil)
//            })
//            // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//            // alertController.addAction(cancelAction)
//            alertController.addAction(defaultAction)
//            present(alertController, animated: true, completion: nil)
//        }

        latString = appDel.latitudeSrtAPD
        longtString = appDel.longitudeSrtAPD
        
        ratingStringFltr = appDel.ratingStringFltrAPD
        priceStringFltr = appDel.priceStringFltrAPD
        capabilityStringFltr = appDel.capabilityStringFltrAPD
        self.fromDateTF.text! = appDel.fromDateTxtAPD as String
        self.toDateTF.text! = appDel.toDateTxtAPD as String
        print (latString,longtString)
        self.getDayCareAPImethod()
        
        if UserDefaults.standard.value(forKey: "selectedName") != nil{
            self.searchMapTF.text! = UserDefaults.standard.value(forKey: "selectedName") as! String
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.last!
        currentLatitude = (userLocation.coordinate.latitude)
        currentLongitude = (userLocation.coordinate.longitude)
       // locationManager.stopUpdatingHeading()
       // print(currentLatitude,currentLongitude)

    }
 
    func getDayCareAPImethod () -> Void
    {
        self.marker.map = nil
        self.mapView.clear()
        
        fromDateTF.text! = String(fromDateTF.text!.replacingOccurrences(of: " ", with: ""))
        toDateTF.text! = String(toDateTF.text!.replacingOccurrences(of: " ", with: ""))
        
        let baseURL: String  = String(format: "%@all_daycare/",Constants.mainURL)
        let  params = "from_date=\(self.fromDateTF.text!)&to_date=\(self.toDateTF.text!)&rating=\(ratingStringFltr)&price=\(priceStringFltr)&capabilities=\(capabilityStringFltr)&latitude=\(latString)&longitude=\(longtString)&alldata=\("")&current_latitude=\(currentLatitude)&current_longitude=\(currentLongitude)"
        print(params)

        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
              DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = jsonDic as NSDictionary
            if (dic.object(forKey: "status") as! Bool) == true
            {
//      self.dataArraySearch = dic.object(forKey: "data") as! NSArray
//      self.mainArraySearch = dic.object(forKey: "data") as! NSArray
//      self.searchTableView.reloadData()
                
                self.dataArray = dic.object(forKey: "data") as! NSArray
                
                self.latitudeArray = self.dataArray.value(forKey: "latitude") as! NSArray
                self.longitudeArray = self.dataArray.value(forKey: "longitude") as! NSArray
                self.dyCreNameAry = self.dataArray.value(forKey: "daycare_name") as! NSArray
                
                for i in 0..<self.dataArray.count
                {
                    
                    let lat: String? = self.latitudeArray.object(at: i) as? String
                    let longi: String? = self.longitudeArray.object(at: i) as? String
                    let doubleLat = Double(lat!)
                    let doubleLong = Double(longi!)
                    if lat == ""
                    {
                    }
                    else if longi == ""
                    {
                    }
                    else
                    {
                        self.marker = GMSMarker()
                        self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                        self.marker.title = self.dyCreNameAry.object(at: i) as? String
                        self.marker.userData = self.dataArray.object(at: i) as? NSDictionary
                        self.marker.icon = #imageLiteral(resourceName: "Map-icon")
                        self.marker.map = self.mapView
                        
                        if UserDefaults.standard.object(forKey: "open") != nil
                        {
                            self.camera = GMSCameraPosition.camera(withLatitude: self.currentLatitude, longitude:self.currentLongitude, zoom: 17.0)
                            self.mapView.animate(to: self.camera)
                        }
                        else{
                             self.camera = GMSCameraPosition.camera(withLatitude: Double((self.latitudeArray.object(at: 0) as? String)!)!, longitude: Double((self.longitudeArray.object(at: 0) as? String)!)!, zoom: 17.0)
                        self.mapView.animate(to: self.camera)
                            
                            UserDefaults.standard.removeObject(forKey: "open")
                        }
                       
                        if self.appDel.searchDoubleLat != 0 && self.appDel.searchDoubleLong != 0
                        {
                          self.camera = GMSCameraPosition.camera(withLatitude: self.appDel.searchDoubleLat, longitude: self.appDel.searchDoubleLong, zoom: 17.0)
                          self.mapView.animate(to: self.camera)
                            
                        print(self.appDel.searchDoubleLat,self.appDel.searchDoubleLong)
                        }
                    }
                }
            
            }
            else
            {
                self.marker.map = nil
                self.mapView.clear()
                self.dataArray = NSArray()
//              self.dataArraySearch = NSArray()
//              self.mainArraySearch = NSArray()
//              self.searchTableView.reloadData()
                if self.latString == ""
                {
                    self.latString = String(self.currentLatitude)
                }
                if self.longtString == ""
                {
                    self.longtString = String(self.currentLongitude)
                }
                self.camera = GMSCameraPosition.camera(withLatitude: Double(self.latString)!, longitude: Double(self.longtString)!, zoom: 17.0)
                self.mapView.animate(to: self.camera)
                self.currentLocMarker = GMSMarker()
                
                self.currentLocMarker.position = CLLocationCoordinate2D(latitude: Double(self.latString)!, longitude: Double(self.longtString)!)
                self.currentLocMarker.icon = #imageLiteral(resourceName: "Location-Blue")
                self.currentLocMarker.map = self.mapView
                
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: "No daycare found", view: self)
                 self.tabBarController?.tabBar.isHidden = false
            }
          }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
             self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    
// MARK:  Google Maps Delegate Methods
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let markerDataAry: NSDictionary = marker.userData as! NSDictionary
        let idStr : String = markerDataAry.value(forKey: "id") as! String
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutDayCareVc") as? AboutDayCareVc
        self.navigationController?.pushViewController(myVC!, animated: true)
        myVC?.daycareID = idStr
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       // searchTableView.isHidden = true
        self.searchMapTF.resignFirstResponder()
        //self.searchMapTF.text! = ""
    }
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        let markerDataAry: NSDictionary = marker.userData as! NSDictionary
//        let idStr : String = markerDataAry.value(forKey: "id") as! String
//        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutDayCareVc") as? AboutDayCareVc
//        self.navigationController?.pushViewController(myVC!, animated: true)
//        myVC?.daycareID = idStr
//      return true
//    }
    
    @IBAction func currentLocationBtnAction(_ sender: Any) {
         UserDefaults.standard.removeObject(forKey: "open")
       // searchTableView.isHidden = true
        self.searchMapTF.resignFirstResponder()
        self.searchMapTF.text! = ""
        self.searchTFpopUp.resignFirstResponder()
        self.searchTFpopUp.text! = ""
        
        
        self.appDel.searchDoubleLat = 0
        self.appDel.searchDoubleLong = 0
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        //self.mapView.isMyLocationEnabled = true
        
        self.marker.map = nil
        self.mapView.clear()
        
        latString = String(currentLatitude)
        longtString = String(currentLongitude)
        self.getDayCareAPImethod()
        
        
        UserDefaults.standard.set(self.searchMapTF.text!, forKey: "selectedName")
        UserDefaults.standard.synchronize()
        
    }
   
    
   
    
    //MARK: TableView Delegates and Datasource:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == searchTableView
        {
            return 50
        }else{
            return 45
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == searchTableView
        {
            return self.dataArraySearch.count
        }else{
            return self.capableDataArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        
        if tableView == searchTableView
        {
            let identifier = "TSearchableViewCell"
            searchCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TSearchableViewCell
            if searchCell == nil
            {
                tableView.register(UINib(nibName: "TSearchableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                searchCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TSearchableViewCell
            }
            
            searchCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            searchCell.cityLabel.text! = String(format:"%@",(self.dataArraySearch.object(at: indexPath.row) as! NSDictionary).object(forKey: "Address") as! String)
            
            searchCell.dayCareLbl.text! = (self.dataArraySearch.object(at: indexPath.row) as! NSDictionary).object(forKey: "daycare_name") as! String
            
            
            
            return searchCell

        }else{
            let identifier = "capableCell"
            Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? capableCell
            if Cell == nil
            {
                tableView.register(UINib(nibName: "capableCell", bundle: nil), forCellReuseIdentifier: identifier)
                Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? capableCell
            }
            
            Cell.nameLbl.text! = (capableDataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "capability") as! String
            
            let check = selectionChildArray.object(at: indexPath.row) as! Bool
            
            if check == true {
                Cell.imageCapabl.image = #imageLiteral(resourceName: "CheckBokRight")
            }else
            {
                Cell.imageCapabl.image = #imageLiteral(resourceName: "UnChkSquare")
            }

             return Cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == searchTableView
        {
            // searchTableView.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            searchPopView.isHidden = true
            searchPopView.removeFromSuperview()
            searchTFpopUp.text! = ""
            self.searchTFpopUp.resignFirstResponder()
            
            self.searchMapTF.text! = String(format:"%@",(self.dataArraySearch.object(at: indexPath.row) as! NSDictionary).object(forKey: "Address") as! String)
            
            UserDefaults.standard.set(self.searchMapTF.text!, forKey: "selectedName")
            UserDefaults.standard.synchronize()
            
            let lat: String? = (self.dataArraySearch.object(at: indexPath.row) as! NSDictionary).object(forKey: "latitude") as? String
            let longi: String? = (self.dataArraySearch.object(at: indexPath.row) as! NSDictionary).object(forKey: "longitude") as? String

            appDel.latitudeSrtAPD = lat!
            appDel.longitudeSrtAPD = longi!
            
            self.appDel.searchDoubleLat = Double(lat!)!
            self.appDel.searchDoubleLong = Double(longi!)!
            if lat == ""
            {
                self.appDel.searchDoubleLat = 0.0
            }
            if longi == ""
            {
                self.appDel.searchDoubleLong = 0.0
            }
            
    //   self.currentLocMarker = GMSMarker()
    //   self.currentLocMarker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
    //   self.currentLocMarker.icon = #imageLiteral(resourceName: "Location-Blue")
    //   self.currentLocMarker.map = self.mapView
            
            self.marker.map = nil
            self.mapView.clear()
            
//            camera = GMSCameraPosition.camera(withLatitude: doubleLat!, longitude: doubleLong!, zoom: 12.0)
//            self.mapView.animate(to: camera)
//            self.mapView.isMyLocationEnabled = true
            
            latString = lat!
            longtString = longi!
            UserDefaults.standard.removeObject(forKey: "open")
            self.getDayCareAPImethod()
            
            
            
        }else{
            let check = selectionChildArray.object(at: indexPath.row) as! Bool
            selectionChildArray.replaceObject(at: indexPath.row, with: !check)
            capabilityTableView.reloadData()
            appDel.selectionChildArrayAD = selectionChildArray
        }
    }
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       // self.searchTableView.isHidden=true
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        if textField == searchMapTF{
          //  searchTableView.isHidden = false
        }
    }
 
    @IBAction func searchTFeditingChangedAction(_ sender: UITextField) {
        
        self.searchDayCareAPImethod()
        
//        let arr = NSMutableArray()
//        if sender.text?.trimmingCharacters(in: .whitespaces).characters.count == 0
//        {   //self.view.endEditing(true)
//            self.dataArraySearch = mainArraySearch
//            self.searchTableView.reloadData()
//        }else
//        {
//            for item in 0..<mainArraySearch.count {
//                if ((mainArraySearch.object(at: item) as! NSDictionary).object(forKey: "daycare_name") as! String).uppercased().contains(sender.text!.trimmingCharacters(in: .whitespaces).uppercased()) || ((mainArraySearch.object(at: item) as! NSDictionary).object(forKey: "address") as! String).uppercased().contains(sender.text!.trimmingCharacters(in: .whitespaces).uppercased())
//                {
//                    arr.add(mainArraySearch.object(at: item) as! NSDictionary)
//                }
//            }
//            self.dataArraySearch = arr
//        }
//        if self.dataArraySearch.count == 0
//        {
//            self.searchTableView.reloadData()
//          
//        }
//        if self.dataArraySearch.count != 0 {
//            
//            self.searchTableView.reloadData()
//        }
    }
    
  //MARK: Filter Button Clicked:
    
    @IBAction func filterButtonAction(_ sender: Any) {
        
       
       // searchTableView.isHidden = true
        self.view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        
        popUpView.isHidden = false
        popUpView.frame = CGRect(x:0, y:0 , width:self.view.frame.width, height:self.view.frame.height)
        popUpView.backgroundColor = UIColor.white
        self.view.addSubview(popUpView)
        
        let navView = UIView()
        navView.frame = CGRect(x:0, y:0 , width:self.view.frame.width, height:64)
        navView.backgroundColor = #colorLiteral(red: 0.1698594987, green: 0.5732039809, blue: 0.6444239616, alpha: 1)
        popUpView.addSubview(navView)
        
        let crossBackButton = UIButton()
        crossBackButton.frame = CGRect(x:5, y:20, width:40, height:40)
        crossBackButton.setImage(#imageLiteral(resourceName: "BackButtonIcon"), for: UIControlState.normal)
        crossBackButton.addTarget(self, action: #selector(MapViewController.crossButtonAction(_:)), for: UIControlEvents.touchUpInside)
        crossBackButton.layer.cornerRadius = 4
        navView.addSubview(crossBackButton)
        
        let scrollViewFltr = UIScrollView()
        scrollViewFltr.frame = CGRect(x:0, y:64 , width:self.view.frame.width, height:self.view.frame.height-104)
        scrollViewFltr.backgroundColor = #colorLiteral(red: 0.8750031865, green: 0.8750031865, blue: 0.8750031865, alpha: 1)
        scrollViewFltr.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height-60+(44 * CGFloat(self.capableDataArray.count)))
        popUpView.addSubview(scrollViewFltr)
        
        
        filtrView.frame = CGRect(x:0, y:0 , width:self.view.frame.width, height:50)
        filtrView.backgroundColor = #colorLiteral(red: 0.9962752461, green: 1, blue: 0.9999060035, alpha: 1)
        scrollViewFltr.addSubview(filtrView)
        
        
        filtrImgVw.frame = CGRect(x:10, y:10 , width:30, height:30)
        filtrImgVw.image = #imageLiteral(resourceName: "FilterBlack")
        filtrView.addSubview(filtrImgVw)
        
        
        filterVwLbl.frame = CGRect(x:50, y:10, width:140, height:30)
        filterVwLbl.text="Filters"
        filterVwLbl.font =  UIFont(name:"Helvetica-Medium", size: 20)
        filterVwLbl.textColor=UIColor.darkGray
        filtrView.addSubview(filterVwLbl)
        
        
        dateRangeLbl.frame = CGRect(x:0, y:filtrView.frame.origin.y+50, width:self.view.frame.width-50, height:40)
        dateRangeLbl.text="   By Date Range"
        dateRangeLbl.font =  UIFont(name:"Helvetica-Medium", size: 18)
        dateRangeLbl.textColor=UIColor.darkGray
        scrollViewFltr.addSubview(dateRangeLbl)
        
        
        dateLineLbl.frame = CGRect(x:0, y:dateRangeLbl.frame.origin.y+40, width:self.view.frame.width, height:2)
        dateLineLbl.backgroundColor=UIColor.white
        scrollViewFltr.addSubview(dateLineLbl)
        
        
        dateHiddenBtn.frame = CGRect(x:self.view.frame.size.width-40, y:dateRangeLbl.frame.origin.y+2, width:34, height:34)
        dateHiddenBtn.setImage(#imageLiteral(resourceName: "UncheckBlk"), for: UIControlState.normal)
        dateHiddenBtn.addTarget(self, action: #selector(MapViewController.dateHiddenButtonAction(_:)), for: UIControlEvents.touchUpInside)
        scrollViewFltr.addSubview(dateHiddenBtn)
        dateHiddenBtn.isSelected = true
        
        
       
        dateRangeVw.frame = CGRect(x:0, y:dateRangeLbl.frame.origin.y+2 , width:self.view.frame.width, height:2)
        dateRangeVw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scrollViewFltr.addSubview(dateRangeVw)
        dateRangeVw.isHidden = true
        
        
        fromDateTF.frame = CGRect(x:10, y:5, width:self.view.frame.size.width/2-20, height:40)
        fromDateTF.delegate = self
        fromDateTF.placeholder = "From"
        fromDateTF.placeHolderColor=UIColor.darkGray
        fromDateTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        fromDateTF.lineColor=UIColor.clear
        fromDateTF.selectedLineColor=UIColor.clear
        fromDateTF.autocorrectionType = UITextAutocorrectionType.no
        dateRangeVw.addSubview(fromDateTF)
        
        toDateTF.frame = CGRect(x:self.view.frame.size.width/2+10, y:5, width:self.view.frame.size.width/2-20, height:40)
        toDateTF.delegate = self
        toDateTF.placeholder = "To"
        toDateTF.placeHolderColor=UIColor.darkGray
        toDateTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        toDateTF.lineColor=UIColor.clear
        toDateTF.selectedLineColor=UIColor.clear
        toDateTF.autocorrectionType = UITextAutocorrectionType.no
        dateRangeVw.addSubview(toDateTF)
        
        
        
       let fromClndrImage = UIImageView()
        fromClndrImage.frame = CGRect(x:fromDateTF.frame.size.width-30, y:10, width:20, height:20)
        fromClndrImage.image = #imageLiteral(resourceName: "Calendar Gary")
        fromDateTF.addSubview(fromClndrImage)
        
        
        toClndrImage.frame = CGRect(x:toDateTF.frame.size.width-30, y:10, width:20, height:20)
        toClndrImage.image = #imageLiteral(resourceName: "Calendar Gary")
        toDateTF.addSubview(toClndrImage)
        
        let fromButton = UIButton()
        fromButton.frame = CGRect(x:0, y:0, width:fromDateTF.frame.size.width, height:toDateTF.frame.size.height)
        fromButton.addTarget(self, action: #selector(MapViewController.fromButtonAction(_:)), for: UIControlEvents.touchUpInside)
        fromDateTF.addSubview(fromButton)
        
        let toButton = UIButton()
        toButton.frame = CGRect(x:0, y:0, width:toDateTF.frame.size.width, height:toDateTF.frame.size.height)
        toButton.addTarget(self, action: #selector(MapViewController.toButtonAction(_:)), for: UIControlEvents.touchUpInside)
        toDateTF.addSubview(toButton)
        
        self.fromDateTF.text! = appDel.fromDateTxtAPD as String
        self.toDateTF.text! = appDel.toDateTxtAPD as String
        
        
        
        //Rating View:
        ratingLbl.frame = CGRect(x:0, y:dateLineLbl.frame.origin.y+2, width:self.view.frame.width, height:40)
        ratingLbl.text="   By Rating"
        ratingLbl.font =  UIFont(name:"Helvetica-Medium", size: 18)
        ratingLbl.textColor=UIColor.darkGray
        scrollViewFltr.addSubview(ratingLbl)
        
      
        ratingVw.frame = CGRect(x:0, y:ratingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
        ratingVw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scrollViewFltr.addSubview(ratingVw)
        
        fiveStrButton.frame = CGRect(x:10, y:15, width:25, height:25)
        fiveStrButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
        fiveStrButton.addTarget(self, action: #selector(MapViewController.fiveStarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        ratingVw.addSubview(fiveStrButton)
        fiveStrButton.isSelected = true
        if starFiveStr == "5"
        {
        fiveStrButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
        fiveStrButton.isSelected = false
        }
       
        fiveStrLbl.frame = CGRect(x:50, y:fiveStrButton.frame.size.height/2-5, width:100, height:16)
        fiveStrLbl.text=" 5 Stars"
        fiveStrLbl.font =  UIFont(name:"Helvetica", size: 10)
        fiveStrLbl.textColor=UIColor.darkGray
        ratingVw.addSubview(fiveStrLbl)
        
        fiveStrImage.frame = CGRect(x:50, y:fiveStrButton.frame.size.height/2+15, width:90, height:16)
        fiveStrImage.image = #imageLiteral(resourceName: "Forward-1")
        ratingVw.addSubview(fiveStrImage)
        
        fourStrButton.frame = CGRect(x:10, y:65, width:25, height:25)
        fourStrButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
        fourStrButton.addTarget(self, action: #selector(MapViewController.fourStarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        ratingVw.addSubview(fourStrButton)
        fourStrButton.isSelected = true
        if starFourStr == "4"
        {
        fourStrButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
        fourStrButton.isSelected = false
        }
        
        fourStrLbl.frame = CGRect(x:50, y:fourStrButton.frame.origin.y-5, width:100, height:16)
        fourStrLbl.text=" 4 Stars"
        fourStrLbl.font =  UIFont(name:"Helvetica", size: 10)
        fourStrLbl.textColor=UIColor.darkGray
        ratingVw.addSubview(fourStrLbl)
        
        
        fourStrImage.frame = CGRect(x:50, y:fourStrButton.frame.origin.y+15, width:60, height:16)
        fourStrImage.image = #imageLiteral(resourceName: "fourStar")
        ratingVw.addSubview(fourStrImage)
        
        threeStrButton.frame = CGRect(x:10, y:115, width:25, height:25)
        threeStrButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
        threeStrButton.addTarget(self, action: #selector(MapViewController.threeStarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        ratingVw.addSubview(threeStrButton)
        threeStrButton.isSelected = true
        if starThreeStr == "3"
        {
        threeStrButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
        threeStrButton.isSelected = false
        }
        
        threeStrLbl.frame = CGRect(x:50, y:threeStrButton.frame.origin.y-5, width:100, height:16)
        threeStrLbl.text=" 3 Stars"
        threeStrLbl.font =  UIFont(name:"Helvetica", size: 10)
        threeStrLbl.textColor=UIColor.darkGray
        ratingVw.addSubview(threeStrLbl)
        
        
        threeStrImage.frame = CGRect(x:50, y:threeStrButton.frame.origin.y+15, width:50, height:16)
        threeStrImage.image = #imageLiteral(resourceName: "threeStr")
        ratingVw.addSubview(threeStrImage)
        
       
        priceingLbl.frame = CGRect(x:0, y:ratingVw.frame.origin.y+150, width:self.view.frame.width, height:40)
        priceingLbl.text="   By Slots"
        priceingLbl.font =  UIFont(name:"Helvetica-Medium", size: 18)
        priceingLbl.textColor=UIColor.darkGray
        scrollViewFltr.addSubview(priceingLbl)
        
       
        priceVw.frame = CGRect(x:0, y:priceingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
        priceVw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scrollViewFltr.addSubview(priceVw)
        
        dollerOne.frame = CGRect(x:10, y:15, width:25, height:25)
        dollerOne.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
        dollerOne.addTarget(self, action: #selector(MapViewController.dollerOneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        priceVw.addSubview(dollerOne)
        dollerOne.isSelected = true
        if fullDayStr == "1"{
        dollerOne.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
        dollerOne.isSelected = false
        }
        
        dollerTwo.frame = CGRect(x:10, y:65, width:25, height:25)
        dollerTwo.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
        dollerTwo.addTarget(self, action: #selector(MapViewController.dollerTwoButtonAction(_:)), for: UIControlEvents.touchUpInside)
        priceVw.addSubview(dollerTwo)
        dollerTwo.isSelected = true
        if firstHlfStr == "2"{
            dollerTwo.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            dollerTwo.isSelected = false
        }
        
        dollerThree.frame = CGRect(x:10, y:115, width:25, height:25)
        dollerThree.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
        dollerThree.addTarget(self, action: #selector(MapViewController.dollerThreeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        priceVw.addSubview(dollerThree)
        dollerThree.isSelected = true
        if secondHlfStr == "3"{
        dollerThree.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
        dollerThree.isSelected = false
        }
        
        
        dlrOneLbl.frame = CGRect(x:50, y:dollerOne.frame.origin.y, width:100, height:25)
        dlrOneLbl.text="Full Day"
        dlrOneLbl.font =  UIFont(name:"Helvetica", size: 13)
        dlrOneLbl.textColor=UIColor.darkGray
        priceVw.addSubview(dlrOneLbl)
        
        
        dlrTwoLbl.frame = CGRect(x:50, y:dollerTwo.frame.origin.y, width:100, height:25)
        dlrTwoLbl.text="First Half"
        dlrTwoLbl.font =  UIFont(name:"Helvetica", size: 13)
        dlrTwoLbl.textColor=UIColor.darkGray
        priceVw.addSubview(dlrTwoLbl)
        
        
        dlrThreeLbl.frame = CGRect(x:50, y:dollerThree.frame.origin.y, width:100, height:25)
        dlrThreeLbl.text="Second Half"
        dlrThreeLbl.font =  UIFont(name:"Helvetica", size: 13)
        dlrThreeLbl.textColor=UIColor.darkGray
        priceVw.addSubview(dlrThreeLbl)
        
        
        capabilityLbl.frame = CGRect(x:0, y:priceVw.frame.origin.y+150, width:self.view.frame.width, height:40)
        capabilityLbl.text="   Facility Type"
        capabilityLbl.font =  UIFont(name:"Helvetica-Medium", size: 18)
        capabilityLbl.textColor=UIColor.darkGray
        scrollViewFltr.addSubview(capabilityLbl)
        
        
        capabilityVw.frame = CGRect(x:0, y:capabilityLbl.frame.origin.y+40 , width:self.view.frame.width, height:200)
        capabilityVw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       // scrollViewFltr.addSubview(capabilityVw)
        
         selectionChildArray = appDel.selectionChildArrayAD
        
        capabilityTableView.frame = CGRect(x:0, y:capabilityLbl.frame.origin.y+40 , width:self.view.frame.width, height:44 * CGFloat(self.capableDataArray.count))
        capabilityTableView.delegate=self
        capabilityTableView.dataSource=self
        capabilityTableView.estimatedRowHeight = 35
        capabilityTableView.isScrollEnabled = false
        scrollViewFltr.addSubview(capabilityTableView)
        capabilityTableView.reloadData()
        
        if capableDataArray.count == 0
        {
        self.capabilityAPImethod()
        }
        
        submitBtn.frame = CGRect(x:self.view.frame.size.width/2+1, y:popUpView.frame.size.height-40, width:self.view.frame.size.width/2-1, height:40)
        submitBtn.setTitle("SUBMIT", for: .normal)
        submitBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 14)
        submitBtn.backgroundColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.addTarget(self, action: #selector(MapViewController.submitButtonAction(_:)), for: UIControlEvents.touchUpInside)
        submitBtn.layer.cornerRadius = 2
        popUpView.addSubview(submitBtn)
        
        clearBtn.frame = CGRect(x:0, y:popUpView.frame.size.height-40, width:self.view.frame.size.width/2-1, height:40)
        clearBtn.setTitle("CLEAR", for: .normal)
        clearBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 14)
        clearBtn.backgroundColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        clearBtn.setTitleColor(UIColor.white, for: .normal)
        clearBtn.addTarget(self, action: #selector(MapViewController.clearButtonAction(_:)), for: UIControlEvents.touchUpInside)
        clearBtn.layer.cornerRadius = 2
        popUpView.addSubview(clearBtn)

        if self.fromDateTF.text!.characters.count > 1 && self.toDateTF.text!.characters.count > 1
        {
            dateHiddenBtn.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            dateHiddenBtn.isSelected = false
            dateRangeVw.isHidden = false
            
            dateRangeVw.frame = CGRect(x:0, y:dateRangeLbl.frame.origin.y+40 , width:self.view.frame.width, height:50)
            ratingLbl.frame = CGRect(x:0, y:dateRangeVw.frame.origin.y+50, width:self.view.frame.width, height:40)
            ratingVw.frame = CGRect(x:0, y:ratingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
            priceingLbl.frame = CGRect(x:0, y:ratingVw.frame.origin.y+150, width:self.view.frame.width, height:40)
            priceVw.frame = CGRect(x:0, y:priceingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
            capabilityLbl.frame = CGRect(x:0, y:priceVw.frame.origin.y+150, width:self.view.frame.width, height:40)
            capabilityTableView.frame = CGRect(x:0, y:capabilityLbl.frame.origin.y+40 , width:self.view.frame.width, height:44 * CGFloat(self.capableDataArray.count))
            
        }
        else{
            fromDateTF.text! = " "
            toDateTF.text! = " "
        }
}
    

func clearButtonAction(_ sender: UIButton!) {
    
        let alertController = UIAlertController(title: "Kinder Drop", message: "Do you want clear filter", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
            
            self.popUpView.isHidden=true
            self.tabBarController?.tabBar.isHidden = false
            for item in 0..<self.selectionChildArray.count
            {
                let check = self.selectionChildArray.object(at: item) as! Bool
                if check == true
                {
                let check = self.selectionChildArray.object(at: item) as! Bool
                 self.selectionChildArray.replaceObject(at: item, with: !check)
                }
            }
            self.filterNilMethod()
//            self.latString = String(self.currentLatitude)
//            self.longtString = String(self.currentLongitude)
            self.getDayCareAPImethod()
            
            
            alertController.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert :UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func dateHiddenButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            dateHiddenBtn.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            dateRangeVw.isHidden = false
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d'/'MM'/'yyyy'"
            fromDateTF.text! = formatter.string(from: curntDate as Date)
            
            let tomorrowDate: Date? = nextDayDate.addingTimeInterval(60*60*24*1)
            let tmrwDateFormatter = DateFormatter()
            tmrwDateFormatter.dateFormat = "d'/'MM'/'yyyy'"
            toDateTF.text! = tmrwDateFormatter.string(from: tomorrowDate!)
            
            dateRangeVw.frame = CGRect(x:0, y:dateRangeLbl.frame.origin.y+40 , width:self.view.frame.width, height:50)
            ratingLbl.frame = CGRect(x:0, y:dateRangeVw.frame.origin.y+50, width:self.view.frame.width, height:40)
            ratingVw.frame = CGRect(x:0, y:ratingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
            priceingLbl.frame = CGRect(x:0, y:ratingVw.frame.origin.y+150, width:self.view.frame.width, height:40)
            priceVw.frame = CGRect(x:0, y:priceingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
            capabilityLbl.frame = CGRect(x:0, y:priceVw.frame.origin.y+150, width:self.view.frame.width, height:40)
            capabilityTableView.frame = CGRect(x:0, y:capabilityLbl.frame.origin.y+40 , width:self.view.frame.width, height:44 * CGFloat(self.capableDataArray.count))
            
        }else{
            
            dateHiddenBtn.setImage(#imageLiteral(resourceName: "UncheckBlk"), for: UIControlState.normal)
            sender.isSelected = true
            dateRangeVw.isHidden = true
            
            fromDateTF.text! = " "
            toDateTF.text! = " "
            appDel.fromDateTxtAPD = ""
            appDel.toDateTxtAPD = ""
            
            ratingLbl.frame = CGRect(x:0, y:dateRangeVw.frame.origin.y+2, width:self.view.frame.width, height:40)
            dateRangeVw.frame = CGRect(x:0, y:dateRangeLbl.frame.origin.y+40 , width:self.view.frame.width, height:0)
            
            ratingVw.frame = CGRect(x:0, y:ratingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
            priceingLbl.frame = CGRect(x:0, y:ratingVw.frame.origin.y+150, width:self.view.frame.width, height:40)
            priceVw.frame = CGRect(x:0, y:priceingLbl.frame.origin.y+40 , width:self.view.frame.width, height:150)
            capabilityLbl.frame = CGRect(x:0, y:priceVw.frame.origin.y+150, width:self.view.frame.width, height:40)
            capabilityTableView.frame = CGRect(x:0, y:capabilityLbl.frame.origin.y+40 , width:self.view.frame.width, height:44 * CGFloat(self.capableDataArray.count))
            
        }
    }
    
    // MARK: cross Button Action:
    func crossButtonAction(_ sender: UIButton!) {
        popUpView.isHidden = true
        popUpView.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
       // self.filterNilMethod()
    }
    // MARK: from Button Action:
    func fromButtonAction(_ sender: UIButton!) {
        datenum = 1
        self.openCalendarMethod()
    }
    // MARK: To Button Action:
    func toButtonAction(_ sender: UIButton!) {
        datenum = 2
        self.openCalendarMethod()
    }
    
    // MARK: Calendar Delegates:
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
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        singleDate = date
        
        let compare:NSInteger = datesComparison(fromDate: Date(), toDate: date)
        if compare == 2 || compare == 3 {
            
        let dateFormat = date.stringFromFormat("d'/'MM'/'yyyy'")
            
        if  datenum == 1 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d'/'MM'/'yyyy'"
            let fromDateSelected = dateFormatter.date(from: toDateTF
                .text!)
            // let fromDate:Date =  fromDateSelected!
            let compare:NSInteger = datesComparison(fromDate: date, toDate: fromDateSelected!)
            if compare == 2 || compare == 3{
                
               self.fromDateTF.text! = dateFormat
            }else
            {
                AFWrapperClass.alert("Alert!", message: "Please Select  ToDate before Dates only", view: self)
            }
        }
            
        else if datenum == 2
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d'/'MM'/'yyyy'"
            let fromDateSelected = dateFormatter.date(from: fromDateTF.text!)
           // let fromDate:Date =  fromDateSelected!
            let compare:NSInteger = datesComparison(fromDate: date, toDate: fromDateSelected!)
            if compare == 1 || compare == 3 {
                
                self.toDateTF.text! = dateFormat
            }else
            {
                AFWrapperClass.alert("Alert!", message: "Please Select From Date after Dates only", view: self)
            }
        }
        }else
        {
            AFWrapperClass.alert("Alert!", message: "Please Select current Date or future Dates only", view: self)
        }
    }
    
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
    
    // MARK: Stars Button Action:
    func fiveStarButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            fiveStrButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            starFiveStr = "5"
            appDel.fiveStarStrAD = "5"
        } else {
            starFiveStr = ""
            appDel.fiveStarStrAD = ""
            fiveStrButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    func fourStarButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            fourStrButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            starFourStr = "4"
            appDel.fourStarStrAD = "4"
        } else {
            starFourStr = ""
            appDel.fourStarStrAD = ""
            fourStrButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    func threeStarButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            threeStrButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            starThreeStr = "3"
            appDel.threeStarStrAD = "3"
        } else {
            starThreeStr = ""
            appDel.threeStarStrAD = ""
            threeStrButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    
    // MARK: Price Button Actions:
    func dollerOneButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            dollerOne.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            fullDayStr = "1"
            appDel.fullDayStrAD = "1"
        } else {
            fullDayStr = ""
            appDel.fullDayStrAD = ""
            dollerOne.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    func dollerTwoButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            dollerTwo.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            firstHlfStr = "2"
            appDel.firstHlfStrAD = "2"
        } else {
            firstHlfStr = ""
            appDel.firstHlfStrAD = ""
            dollerTwo.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    func dollerThreeButtonAction(_ sender: UIButton!) {
        if sender.isSelected {
            dollerThree.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            secondHlfStr = "3"
            appDel.secondHlfStrAD = "3"
        } else {
            secondHlfStr = ""
            appDel.secondHlfStrAD = ""
            dollerThree.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    
  
    
// MARK: Submit Button Action:
    func submitButtonAction(_ sender: UIButton!) {
        
        UserDefaults.standard.removeObject(forKey: "open")
        
        let starArray = NSMutableArray()
        if starFiveStr.characters.count > 0 {
            starArray.add(starFiveStr)
        }
        if starFourStr.characters.count > 0 {
            starArray.add(starFourStr)
        }
        if starThreeStr.characters.count > 0 {
            starArray.add(starThreeStr)
        }
        ratingStringFltr = starArray.componentsJoined(by: ",")
        
        let priceArray = NSMutableArray()
        if fullDayStr.characters.count > 0 {
            priceArray.add(fullDayStr)
        }
        if firstHlfStr.characters.count > 0 {
            priceArray.add(firstHlfStr)
        }
        if secondHlfStr.characters.count > 0 {
            priceArray.add(secondHlfStr)
        }
        priceStringFltr = priceArray.componentsJoined(by: ",")
        
        let idArray = NSMutableArray()
        for item in 0..<selectionChildArray.count
        {
            let check = selectionChildArray.object(at: item) as! Bool
            if check == true
            {
                let capbleIDs = ((capableDataArray.object(at: item) as! NSDictionary).object(forKey: "capability_id") as? String)!
                idArray.add(capbleIDs)
            }
        }
        capabilityStringFltr = idArray.componentsJoined(by: ",")
        

        self.searchTFpopUp.text! = ""
        self.view.endEditing(true)
        
        
        
        fromDateTF.text! = String(fromDateTF.text!.replacingOccurrences(of: " ", with: ""))
        toDateTF.text! = String(toDateTF.text!.replacingOccurrences(of: " ", with: ""))
        
        let baseURL: String  = String(format: "%@all_daycare/",Constants.mainURL)
        let  params = "from_date=\(self.fromDateTF.text!)&to_date=\(self.toDateTF.text!)&rating=\(ratingStringFltr)&price=\(priceStringFltr)&capabilities=\(capabilityStringFltr)&latitude=\(latString)&longitude=\(longtString)&alldata=\("")&current_latitude=\(currentLatitude)&current_longitude=\(currentLongitude)"
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                
                self.marker.map = nil
                self.mapView.clear()

                self.appDel.ratingStringFltrAPD = self.ratingStringFltr
                self.appDel.priceStringFltrAPD = self.priceStringFltr
                self.appDel.capabilityStringFltrAPD = self.capabilityStringFltr
                
                AFWrapperClass.svprogressHudDismiss(view: self)
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    
                    
                    self.dataArray = dic.object(forKey: "data") as! NSArray
                    
                    print(self.dataArray)
                   // self.mainArray = dic.object(forKey: "data") as! NSArray
                    self.latitudeArray = self.dataArray.value(forKey: "latitude") as! NSArray
                    self.longitudeArray = self.dataArray.value(forKey: "longitude") as! NSArray
                    self.dyCreNameAry = self.dataArray.value(forKey: "daycare_name") as! NSArray
                    
                    for i in 0..<self.dataArray.count
                    {
                        let lat: String? = self.latitudeArray.object(at: i) as? String
                        let longi: String? = self.longitudeArray.object(at: i) as? String
                        let doubleLat = Double(lat!)
                        let doubleLong = Double(longi!)
                        
                        if lat == ""
                        {
                        }
                        else if longi == ""
                        {
                        }
                        else
                        {
                            self.marker = GMSMarker()
                            self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                            self.marker.title = self.dyCreNameAry.object(at: i) as? String
                            //self.marker.snippet = "ChandiGarh"
                            self.marker.userData = self.dataArray.object(at: i) as? NSDictionary
                            self.marker.icon = #imageLiteral(resourceName: "Map-icon")
                            self.marker.map = self.mapView
                            
                            self.camera = GMSCameraPosition.camera(withLatitude: Double((self.latitudeArray.object(at: 0) as? String)!)!, longitude: Double((self.longitudeArray.object(at: 0) as? String)!)!, zoom: 17.0)
                            self.mapView.animate(to: self.camera)
                        }
                    }
                    
                    
                    
                AFWrapperClass.svprogressHudDismiss(view: self)
                self.tabBarController?.tabBar.isHidden = false
                self.popUpView.isHidden = true
                self.popUpView.removeFromSuperview()
                    
                self.appDel.fromDateTxtAPD = self.fromDateTF.text! as NSString
                self.appDel.toDateTxtAPD = self.toDateTF.text! as NSString
                    
                self.appDel.searchDoubleLat = 0
                self.appDel.searchDoubleLong = 0
                }
                else
                {
                    self.marker.map = nil
                    self.mapView.clear()
                    self.dataArray = NSArray()
//                    self.dataArraySearch = NSArray()
//                    self.mainArraySearch = NSArray()
                    
                    if self.latString == ""
                    {
                      self.latString = String(self.currentLatitude)
                    }
                    if self.longtString == ""
                    {
                       self.longtString = String(self.currentLongitude)
                    }
                    
                    self.camera = GMSCameraPosition.camera(withLatitude: Double(self.latString)!, longitude: Double(self.longtString)!, zoom: 17.0)
                    self.mapView.animate(to: self.camera)
                    self.currentLocMarker = GMSMarker()
                    
                    self.currentLocMarker.position = CLLocationCoordinate2D(latitude: Double(self.latString)!, longitude: Double(self.longtString)!)
                    self.currentLocMarker.icon = #imageLiteral(resourceName: "Location-Blue")
                    self.currentLocMarker.map = self.mapView
                    
                    if self.fromDateTF.text!.characters.count > 0 && self.toDateTF.text!.characters.count > 0
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: String(format:"Day care not exist between %@ to %@",self.fromDateTF.text!,self.toDateTF.text!), view: self)
                        
                         self.popUpView.isHidden = false
                    }
                    else{
                       AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "No daycare found", view: self)
                        
                    self.tabBarController?.tabBar.isHidden = false
                    self.popUpView.isHidden = true
                        
                    }
                }
            }
        })
        { (error) in
            
            self.popUpView.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            
            starArray.removeAllObjects()
            priceArray.removeAllObjects()
            //self.filterNilMethod()
        }
    }
 
    func filterNilMethod()-> Void
    {
        self.fromDateTF.text! = " "
        self.toDateTF.text! = " "
        self.priceStringFltr = ""
        self.ratingStringFltr = ""
        self.capabilityStringFltr = ""
        self.starFiveStr = ""
        self.starFourStr = ""
        self.starThreeStr = ""
        self.fullDayStr = ""
        self.firstHlfStr = ""
        self.secondHlfStr = ""
        
        for item in 0..<self.selectionChildArray.count
        {
            let check = self.selectionChildArray.object(at: item) as! Bool
            if check == true
            {
                let check = self.selectionChildArray.object(at: item) as! Bool
                self.selectionChildArray.replaceObject(at: item, with: !check)
            }
        }

        appDel.fromDateTxtAPD = ""
        appDel.toDateTxtAPD = ""
        appDel.fiveStarStrAD = ""
        appDel.fourStarStrAD = ""
        appDel.threeStarStrAD = ""
        appDel.fullDayStrAD = ""
        appDel.firstHlfStrAD = ""
        appDel.secondHlfStrAD = ""
        appDel.ratingStringFltrAPD = ""
        appDel.priceStringFltrAPD = ""
        appDel.capabilityStringFltrAPD = ""
        appDel.selectionChildArrayAD = selectionChildArray
    }
   
// MARK: Search Button Action
    @IBAction func searchButtonAction(_ sender: Any) {
        
        if dataArraySearch.count == 0{
            self.searchDayCareAPImethod()
        }
        
//        self.dataArraySearch = mainArraySearch
//        self.searchTableView.reloadData()
        
        self.tabBarController?.tabBar.isHidden = true
        searchPopView.isHidden = false
        
        searchPopView.frame = CGRect(x:0, y:0 , width:self.view.frame.width, height:self.view.frame.height)
        searchPopView.backgroundColor = UIColor.white
        self.view.addSubview(searchPopView)
        
        let navView = UIView()
        navView.frame = CGRect(x:0, y:0 , width:self.view.frame.width, height:20)
        navView.backgroundColor = #colorLiteral(red: 0.1698594987, green: 0.5732039809, blue: 0.6444239616, alpha: 1)
        searchPopView.addSubview(navView)
        
        backButtonSearch.frame = CGRect(x:5, y:25, width:40, height:50)
        backButtonSearch.setImage(#imageLiteral(resourceName: "BackWordBtn"), for: UIControlState.normal)
        backButtonSearch.addTarget(self, action: #selector(MapViewController.backButtonSearchAction(_:)), for: UIControlEvents.touchUpInside)
        searchPopView.addSubview(backButtonSearch)
        
        sarchTFview.frame = CGRect(x:40, y:25 , width:self.view.frame.width-50, height:44)
        sarchTFview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sarchTFview.layer.borderWidth = 1
        sarchTFview.layer.cornerRadius = 2
        sarchTFview.layer.borderColor = UIColor.lightGray.cgColor
        searchPopView.addSubview(sarchTFview)
        
        searchImage.frame = CGRect(x:5, y:12, width:23, height:23)
        searchImage.image = #imageLiteral(resourceName: "Secrch-black")
        sarchTFview.addSubview(searchImage)
        
        searchTFpopUp.frame = CGRect(x:35, y:5, width:sarchTFview.frame.size.width-40, height:40)
        searchTFpopUp.delegate = self
        searchTFpopUp.placeholder = "Search Location"
        searchTFpopUp.autocorrectionType = UITextAutocorrectionType.no
        searchTFpopUp.addTarget(self, action: #selector(MapViewController.searchTFeditingChangedAction(_:)), for: UIControlEvents.editingChanged)
        sarchTFview.addSubview(searchTFpopUp)

        searchTableView.frame = CGRect(x:0, y:75, width:self.view.frame.size.width, height:searchPopView.frame.size.height-75)
        searchTableView.delegate=self
        searchTableView.dataSource=self
        searchTableView.estimatedRowHeight = 35
        searchTableView.layer.cornerRadius = 2
        searchTableView.layer.borderWidth = 1
        searchTableView.layer.borderColor = UIColor.lightGray.cgColor
        searchPopView.addSubview(searchTableView)
       // searchTableView.isHidden = true
    }
    func backButtonSearchAction(_ sender: UIButton!) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.view.endEditing(true)
        searchPopView.isHidden = true
        searchTFpopUp.text! = ""
        self.searchDayCareAPImethod()
    }
    
    func searchDayCareAPImethod() -> Void
    {
        let baseURL: String  = String(format: "%@keywordserach/",Constants.mainURL)
        let params = String (format:"keyword=%@",searchTFpopUp.text!)
        // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    self.dataArraySearch = dic.object(forKey: "data") as! NSArray
                    self.mainArraySearch = dic.object(forKey: "data") as! NSArray
                    self.searchTableView.reloadData()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    //    AFWrapperClass.alert(Constants.applicationName, message: "No DayCare Found", view: self)
                    //   self.tabBarController?.tabBar.isHidden = false
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //  self.tabBarController?.tabBar.isHidden = false
        }
    }

    
 // MARK: Capabilities Method:
    func capabilityAPImethod() -> Void
    {
        let baseURL: String  = String(format: "%@capabilitylist/",Constants.mainURL)
        let  params = ""
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            DispatchQueue.main.async {
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    self.capableDataArray = dic.object(forKey: "data") as! NSArray
                    for _ in 0..<self.capableDataArray.count
                    {
                        self.selectionChildArray.add(false)
                    }
                  //  self.capableDataArray.constant = 46 * CGFloat(self.dataChildAry.count)
                    self.appDel.selectionChildArrayAD = self.selectionChildArray
                    self.capabilityTableView.reloadData()
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
    
    // MARK: Notifications methods:
    @IBAction func notificationBottonAction(_ sender: Any) {
        //searchTableView.isHidden = true
        self.view.endEditing(true)
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }

    func badgeCountAPImethod () -> Void
    {
        let baseURL: String  = String(format: "%@usercount/",Constants.mainURL)
        let  params = "userid=\(userID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            DispatchQueue.main.async {
                let dic:NSDictionary = jsonDic as NSDictionary
                if (dic.object(forKey: "status") as! Bool) == true
                {
                    let countStr:String = (dic.object(forKey:"data") as! NSDictionary).object(forKey:"count") as! String
                    if countStr == "0"
                    {
                        self.badgeCountLbl.isHidden = true
                    }else{
                        self.badgeCountLbl.isHidden = false
                        self.badgeCountLbl.text! = countStr
                    }
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    //AFWrapperClass.alert(Constants.applicationName, message: "No DayCare Found", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
       
    @IBAction func clearTextFieldButtonAction(_ sender: Any) {
        
        self.appDel.searchDoubleLat = 0
        self.appDel.searchDoubleLong = 0
        
        self.searchMapTF.resignFirstResponder()
        self.searchMapTF.text! = ""
//        self.marker.map = nil
//        self.mapView.clear()
//        
        latString = ""
        longtString = ""
//        self.getDayCareAPImethod()
//        
        appDel.latitudeSrtAPD = ""
        appDel.longitudeSrtAPD = ""
        
        UserDefaults.standard.set(self.searchMapTF.text!, forKey: "selectedName")
        UserDefaults.standard.synchronize()
        
         UserDefaults.standard.removeObject(forKey: "open")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
