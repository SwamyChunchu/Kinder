//
//  ProfileViewController.swift
//  KinderDrop
//
//  Created by amit on 4/6/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore
import CoreLocation
import GooglePlaces


class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,HMDiallingCodeDelegate,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate
{
    var childCell : ChildTableCell!
    
    @IBOutlet weak var prifileNameLbl: UILabel!
    @IBOutlet weak var userNameTF: ACFloatingTextfield!
    @IBOutlet weak var emailTF: ACFloatingTextfield!
    @IBOutlet weak var phoneNumTF: ACFloatingTextfield!
    @IBOutlet weak var passWordTF: ACFloatingTextfield!
    @IBOutlet weak var addressTF: ACFloatingTextfield!
    @IBOutlet weak var adressLineTwo: ACFloatingTextfield!
    @IBOutlet weak var cityTF: ACFloatingTextfield!
    @IBOutlet weak var provinceTF: ACFloatingTextfield!
    @IBOutlet weak var postalCodeTF: ACFloatingTextfield!
    @IBOutlet weak var emergencyContactTF: ACFloatingTextfield!
    
    
    @IBOutlet weak var cityLocationButton: UIButton!
    
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var userID = String()
    var  dataDic = NSDictionary()
    var dataChildAry = NSArray()
    var childNameAry = NSArray()
    var childImageAry = NSArray()
    var childIDAry = NSArray()
    var socialRegStr = String()
    
    @IBOutlet weak var passWrdVwHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmPWvwHightCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var passWrdView: UIView!
    @IBOutlet weak var confirmPwView: UIView!
    @IBOutlet weak var textFldBackView: UIView!
    @IBOutlet weak var backViewHightConstraint: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var childTableHightConstraint: NSLayoutConstraint!
   
    var selectedChildID = String()
    
    var popUpView = UIScrollView()
    var alertView = UIView()
    var mobileTF = ACFloatingTextfield()
    var countryCodeTF = ACFloatingTextfield()
    var countryCodeBtn = UIButton()
    var cancelBtn = UIButton()
    var doneBtn = UIButton()
    var diallingCode = HMDiallingCode()
    
    var  otpPopUpView = UIScrollView()
    var otpAlertView = UIView()
    var cancelOtpBtn = UIButton()
    var resendBtn = UIButton()
    var verifyBtn = UIButton()
    var enterOtpTF = UITextField()
    
    var changePWpopUpView = UIScrollView()
    var pwAlertView = UIView()
    var currentPWTF = ACFloatingTextfield()
    var changePWTF = ACFloatingTextfield()
    var confirmPWTF = ACFloatingTextfield()
    var cancelPWbtn = UIButton()
    var donePWbtn = UIButton()
    
    
    
    
    var locationManager = CLLocationManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var myString = String()
    var   otpID = String()
    
    
    var coordinate = CLLocationCoordinate2D()
    
    @IBOutlet weak var badgeCountLbl: UILabel!
    
     var badgrCountNotf = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myString = "0"
       
        userNameTF.delegate=self
        emailTF.delegate=self
        addressTF.delegate=self
        
        imagePicker.delegate = self
        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
        }
        
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            //            currentLatitude = (locationManager.location?.coordinate.latitude)!
            //            currentLongitude = (locationManager.location?.coordinate.longitude)!
            
        }else
        {
            let alertController = UIAlertController(title: "Kinder Drop", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                alertController.dismiss(animated: true, completion: nil)
            })
            // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            // alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            locationManager.requestWhenInUseAuthorization()
        }
        self.diallingCode.delegate = self
        
        socialRegStr = UserDefaults.standard.value(forKey: "saveRegSocial") as! String
        if socialRegStr == "1" {
            self.passWrdVwHightConstraint.constant = 0
            //self.confirmPWvwHightCnstrnt.constant = 0
            self.passWrdView.isHidden = true
           // self.confirmPwView.isHidden = true
            self.backViewHightConstraint.constant = 510
        }else{
            self.passWrdVwHightConstraint.constant = 50
           // self.confirmPWvwHightCnstrnt.constant = 50
            self.passWrdView.isHidden = false
            //self.confirmPwView.isHidden = false
            self.backViewHightConstraint.constant = 560
        }
        self.userProfileAPIMethod()
        
        self.emergencyContactTF.delegate = self
//        self.emergencyContactTF.addTarget(self, action: #selector(ProfileViewController.emergencyTFeditingChangedAction(_:)), for: UIControlEvents.editingChanged)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        
    }
    
    func methodOfReceivedNotification(notification: Notification){
        
        badgrCountNotf = (notification.object as? String)!
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
        
        self.badgeCountLbl.isHidden = true
        self.badgeCountAPImethod ()
        self.childInfoAPIMethod()
        self.tabBarController?.tabBar.isHidden = false
        
//        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
//            //locationManager.requestWhenInUseAuthorization()
//            currentLatitude = (locationManager.location?.coordinate.latitude)!
//            currentLongitude = (locationManager.location?.coordinate.longitude)!
//        }else{
//            locationManager.requestWhenInUseAuthorization()
//        }
        
        
        if myString == "0" {
            self.setUsersClosestCity()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.last!
        currentLatitude = (userLocation.coordinate.latitude)
        currentLongitude = (userLocation.coordinate.longitude)
        // locationManager.stopUpdatingHeading()
    }
    
    // MARK: Get Country Code  and Delegates
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            if ((error) != nil)
            {
                self.countryCodeTF.text! = ""
            //     AFWrapperClass.alert(Constants.applicationName, message: String(format: "+%@",diallingCode), view: self)
            }
            else{
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if placeMark.isoCountryCode != nil
                {
                    let iosCode = placeMark.isoCountryCode! as String
                    self.diallingCode.getForCountry(iosCode)
                    
                }
            }
        }
    }
    
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        self.countryCodeTF.text! = String(format: "+%@",diallingCode)
        myString = "1"
    }
    public func failedToGetDiallingCode() {
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//   //     let userLocation:CLLocation = locations.last!
////        currentLatitude = (userLocation.coordinate.latitude)
////        currentLongitude = (userLocation.coordinate.longitude)
//        //locationManager.stopUpdatingHeading()
//    }
    
// MARK: -> User Profile Method
    func userProfileAPIMethod () -> Void
    {
        let baseURL: String  = String(format: "%@user_history/",Constants.mainURL)
        let params = "user_id=\(userID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.dataDic = responceDic.object(forKey: "data") as! NSDictionary
                    self.prifileNameLbl.text! = (self.dataDic.object(forKey: "name") as? String)!
                    self.userNameTF.text! = (self.dataDic.object(forKey: "name") as? String)!
                    self.emailTF.text! = (self.dataDic.object(forKey: "email") as? String)!
                    self.phoneNumTF.text! = String(format:"%@",(self.dataDic.object(forKey: "phone") as? String)!)
                    self.addressTF.text! = (self.dataDic.object(forKey: "address") as? String)!
                    self.adressLineTwo.text! = (self.dataDic.object(forKey: "Address2") as? String)!
                    self.cityTF.text! = (self.dataDic.object(forKey: "City") as? String)!
                    self.provinceTF.text! = (self.dataDic.object(forKey: "Province") as? String)!
                    self.postalCodeTF.text! = (self.dataDic.object(forKey: "Postl_code") as? String)!
                    self.emergencyContactTF.text! = (self.dataDic.object(forKey: "Emergency_contact") as? String)!
                    
                    let imageURL: String = (self.dataDic.object(forKey: "profilepic") as? String)!
                    let url = NSURL(string:imageURL)
                    
                    self.profileImage.setShowActivityIndicator(true)
                    self.profileImage.setIndicatorStyle(.gray)
                    self.profileImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "profilePlaceHolder"))
                   
//  let imgData: Data? = UIImageJPEGRepresentation(self.profileImage.image!, 1)
// self.currentSelectedImage = UIImage(data: imgData! as Data)!
//  self.currentSelectedImage=self.profileImage.image!
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "No Data Found", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
// MARK: -> Edit Button Action
    @IBAction func editButtonAction(_ sender: Any)
    {
        userNameTF.isEnabled=true
        addressTF.isEnabled=true
        adressLineTwo.isEnabled=true
       // cityTF.isEnabled=true
        provinceTF.isEnabled=true
        postalCodeTF.isEnabled=true
        emergencyContactTF.isEnabled=true
        userNameTF.becomeFirstResponder()
    cityLocationButton.isUserInteractionEnabled = true
    }
    
//MARK:  -> ImagePicker Controller Delegates
    @IBAction func cameraButtonAction(_ sender: Any)
    {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let pibraryAction = UIAlertAction(title: "From Photo Library", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
            
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
            })
        let cameraction = UIAlertAction(title: "Camera", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.imagePicker.cameraCaptureMode = .photo
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.present(self.imagePicker,animated: true,completion: nil)
         } else {
            AFWrapperClass.alert(Constants.applicationName, message: "Sorry, this device has no camera", view: self)
                }
           })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
            })
        optionMenu.addAction(pibraryAction)
        optionMenu.addAction(cameraction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
        let popOverPresentationController : UIPopoverPresentationController = optionMenu.popoverPresentationController!
        popOverPresentationController.sourceView   = cameraButton
        popOverPresentationController.sourceRect   = cameraButton.bounds
        popOverPresentationController.permittedArrowDirections  = UIPopoverArrowDirection.any
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImage.image = currentSelectedImage
        self.updateProfileImageAPIMethod()
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func updateProfileImageAPIMethod () -> Void
    {
        self.view.endEditing(true)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 0.5)
        if imageData == nil {
            let imgData: Data? = UIImageJPEGRepresentation(self.profileImage.image!, 0.5)
            self.currentSelectedImage = UIImage(data: imgData! as Data)!
            //currentSelectedImage = UIImage(named: "profilePlaceHolder")!
        }
        let parameters = ["user_id"   :userID,
                          "name"      :"",
                          "email"     :"",
                          "mobile"    :"",
                          "gender"    :"",
                          "password"  :"",
                          "address"   :"",
                          "Address2"   :"",
                          "Emergency_contact"   :"",
                          "City"   :"",
                          "Province"   :"",
                          "Postl_code"   :"",
                          "is_social" :""    ] as [String : String]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let image = self.currentSelectedImage
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "profilepic", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:String(format: "%@useredit/",Constants.mainURL))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.result.isSuccess
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        if (response.result.value as! NSDictionary).value(forKey: "status") as! Bool == true
                        {
                            AFWrapperClass.alert(Constants.applicationName, message: "Profile Pic Update Successfully", view: self)
                        }else{
                           AFWrapperClass.alert(Constants.applicationName, message: "Profile Pic not Updated Please try again", view: self)
                        }
                }
                if response.result.isFailure
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let error : NSError = response.result.error! as NSError
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                    }
                }
            case .failure(let error):
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            break
            }
        }
    }
    
  //MARK:  -> Profile Button Action:
    @IBAction func profileButtonAction(_ sender: UIButton)
    {
    var message = String()
    if (userNameTF.text?.isEmpty)!
    {
      message = "Please enter Name"
    }
        else if (addressTF.text?.isEmpty)!
    {
        message = "Please enter Address"
    }

    if message.characters.count > 1 {
    AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
    }else{
        self.profileInfoUpdateAPIMethod()
    }
    }
    
    func profileInfoUpdateAPIMethod() -> Void
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        let parameters = ["user_id"   :userID,
                          "name"      :userNameTF.text!,
                          "email"     :"",
                          "mobile"    :"",
                          "gender"    :"",
                          "password"  :passWordTF.text!,
                          "address"   :addressTF.text!,
                          "Address2"   :adressLineTwo.text!,
                          "Emergency_contact"   :emergencyContactTF.text!,
                          "City"   :cityTF.text!,
                          "Province"   :provinceTF.text!,
                          "Postl_code"   :postalCodeTF.text!,
                          "is_social" :"" ,
                          "profilepic":""] as [String : String]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:String(format: "%@useredit/",Constants.mainURL))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.result.isSuccess
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        if (response.result.value as! NSDictionary).value(forKey: "status") as! Bool == true
                        {
                            self.userProfileAPIMethod()
                            self.userNameTF.isEnabled = false
                            self.addressTF.isEnabled = false
                            self.adressLineTwo.isEnabled = false
                        //  self.cityTF.isEnabled = false
                            self.provinceTF.isEnabled = false
                            self.postalCodeTF.isEnabled = false
                            self.emergencyContactTF.isEnabled = false
                            self.cityLocationButton.isUserInteractionEnabled = false
                            
                            AFWrapperClass.alert(Constants.applicationName, message: "Profile Info Update Successfully", view: self)
                        }else{
                            AFWrapperClass.alert(Constants.applicationName, message: "Profile Info not Updated Please try again", view: self)
                        }
                    }
                    if response.result.isFailure
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let error : NSError = response.result.error! as NSError
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                    }
                }
            case .failure(let error):
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            break
            }
        }
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
                    self.childNameAry = (self.dataChildAry.value(forKey: "child_name") as? NSArray)!
                    self.childImageAry = (self.dataChildAry.value(forKey: "profilepic") as? NSArray)!
                    self.childIDAry = (self.dataChildAry.value(forKey: "child_id") as? NSArray)!
                    
                    if self.dataChildAry.count  == 0
                    {
                         self.childTableHightConstraint.constant  = 0
                    }
                    self.childTableHightConstraint.constant  = (CGFloat(self.dataChildAry.count))*44
                    self.childTableView.reloadData()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    //AFWrapperClass.alert(Constants.applicationName, message: "No Daycare Found", view: self)
                    self.childTableHightConstraint.constant  = 0
                }
            }
            
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
   //MARK: TableView Delegates and Datasource:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataChildAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "ChildTableCell"
        childCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChildTableCell
        
        if childCell == nil
        {
            tableView.register(UINib(nibName: "ChildTableCell", bundle: nil), forCellReuseIdentifier: identifier)
            childCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChildTableCell
        }
        childCell.nameLabel.text! = self.childNameAry.object(at: indexPath.row) as! String
        
        let imageURL: String = self.childImageAry.object(at: indexPath.row) as! String
        let url = NSURL(string:imageURL)
        
        childCell.childImageVW.setShowActivityIndicator(true)
        childCell.childImageVW.setIndicatorStyle(.gray)
        childCell.childImageVW.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "profilePlaceHolder"))
        
        
        
        
        
        
        return childCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.selectedChildID = self.childIDAry.object(at: indexPath.row) as! String
        self.childProfileAPIMethod()
    }
    func childProfileAPIMethod () -> Void
    {
        let baseURL: String  = String(format: "%@particular_childhistory/",Constants.mainURL)
        let params = "id=\(selectedChildID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
        DispatchQueue.main.async {
        AFWrapperClass.svprogressHudDismiss(view: self)
        let responceDic:NSDictionary = jsonDic as NSDictionary
        if (responceDic.object(forKey: "status") as! Bool) == true
        {
        let dataDicChild:NSDictionary = responceDic.object(forKey: "data") as! NSDictionary
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateChildProfileVC") as? UpdateChildProfileVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        myVC?.dataDictionary = dataDicChild
        myVC!.childID   = self.selectedChildID
            
        }
        else
            {
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: "Child Info not Found Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
 
     @IBAction func addChildBtn(_ sender: Any) {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AddChildVC") as? AddChildVC
            self.navigationController?.pushViewController(myVC!, animated: true)
    }
   
//MARK: Edit Phone num Methids
    @IBAction func mobileNumEditBtnAction(_ sender: Any) {
        self.editMobNumberMethod()
       //self.resendOTPviewMethod()
    }
    
    @objc private func editMobNumberMethod () -> Void
    {
        self.setUsersClosestCity()
        popUpView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view .addSubview(popUpView)
        
        alertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-120, width:self.view.frame.size.width-60, height:205)
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 5
        popUpView.addSubview(alertView)
        
        let numberLbl = UILabel()
        numberLbl.frame = CGRect(x:0, y:0, width:alertView.frame.size.width, height:50)
        numberLbl.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        numberLbl.layer.cornerRadius = 5
        numberLbl.text = "ENTER NUMBER"
        numberLbl.font =  UIFont(name:"Helvetica-Medium", size: 16)
        numberLbl.textAlignment = .center
        numberLbl.textColor = UIColor.white
        alertView.addSubview(numberLbl)
        
        mobileTF.frame = CGRect(x:100, y:60, width:alertView.frame.size.width-110, height:46)
        mobileTF.delegate = self
        mobileTF.placeholder = "Phone"
        mobileTF.font = UIFont(name: "Helvetica", size: 16)
        mobileTF.placeHolderColor=UIColor.darkGray
        mobileTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        mobileTF.lineColor=UIColor.darkGray
        mobileTF.selectedLineColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        mobileTF.keyboardType=UIKeyboardType.numberPad
        mobileTF.autocorrectionType = UITextAutocorrectionType.no
        alertView.addSubview(mobileTF)
        
        let ccView = UIView()
        ccView.frame =  CGRect(x:10, y:numberLbl.frame.origin.y+60, width:80, height:47)
        ccView.backgroundColor = UIColor.white
        alertView.addSubview(ccView)
        
        let phoneimg = UIImageView()
        phoneimg.frame=CGRect(x:5, y:13, width:18, height:18)
        phoneimg.image = #imageLiteral(resourceName: "Phone-icon")
        ccView.addSubview(phoneimg)
        
        countryCodeTF.frame = CGRect(x:26, y:0, width:48, height:46)
        countryCodeTF.delegate = self
        countryCodeTF.placeholder = "CC"
        countryCodeTF.font = UIFont(name: "Helvetica", size: 14)
        countryCodeTF.placeHolderColor=UIColor.darkGray
        countryCodeTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        countryCodeTF.lineColor=UIColor.darkGray
        countryCodeTF.selectedLineColor=UIColor.clear
        countryCodeTF.autocorrectionType = UITextAutocorrectionType.no
        ccView.addSubview(countryCodeTF)
        
        countryCodeBtn.frame = CGRect(x:0, y:0, width:75, height:46)
        countryCodeBtn.backgroundColor=UIColor.clear
        countryCodeBtn.addTarget(self, action: #selector(ProfileViewController.countryCodeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        ccView.addSubview(countryCodeBtn)
 
        cancelBtn.frame = CGRect(x:10, y:mobileTF.frame.origin.y+80, width:alertView.frame.size.width/2-20, height:40)
        cancelBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(UIColor.darkGray, for: .normal)
        cancelBtn.addTarget(self, action: #selector(ProfileViewController.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelBtn.layer.cornerRadius = 2
        alertView.addSubview(cancelBtn)
        
        doneBtn.frame = CGRect(x:alertView.frame.size.width/2+10, y:mobileTF.frame.origin.y+80, width:alertView.frame.size.width/2-20, height:40)
        doneBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        //registerButton.setTitleColor(UIColor.white, for: .normal)
        doneBtn.backgroundColor=#colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.addTarget(self, action: #selector(ProfileViewController.doneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        doneBtn.layer.cornerRadius = 2
        alertView.addSubview(doneBtn)
    }
    
    func countryCodeButtonAction(_ sender : UIButton)
    {
        self.view.endEditing(true)
        let vc = SLCountryPickerViewController()
        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
            self.diallingCode.getForCountry(code!)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cancelButtonAction(_ sender : UIButton)
    {
        self.mobileTF.text! = ""
        self.popUpView.removeFromSuperview()
    }
    func doneButtonAction(_ sender : UIButton)
    {
        var message = String()
        if (countryCodeTF.text?.isEmpty)!
        {
            message = "Please choose country code"
        }
        else if (mobileTF.text?.isEmpty)!
        {
            message = "Please enter Phone number"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.EditMobileNumAPIMethod()
        }
    }
    
    func EditMobileNumAPIMethod () -> Void
    {
        self.view.endEditing(true)
        var mobileString = String(format:"%@%@",countryCodeTF.text!,mobileTF.text!)
        mobileString = String(mobileString.replacingOccurrences(of: "+", with: "%2B"))

        let baseURL: String  = String(format: "%@useredit_mobile/",Constants.mainURL)
        let params = "mobile_no=\(mobileString)&user_id=\(userID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.otpID = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! String
                    self.popUpView.removeFromSuperview()
                    self.mobileTF.text! = ""
                    self.resendOTPviewMethod()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Mobile  already exist.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    @objc private func resendOTPviewMethod () -> Void
    {
        otpPopUpView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        otpPopUpView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view .addSubview(otpPopUpView)
        
        otpAlertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-120, width:self.view.frame.size.width-60, height:205)
        otpAlertView.backgroundColor = UIColor.white
        otpAlertView.layer.cornerRadius = 5
        otpPopUpView.addSubview(otpAlertView)
        
        let numberLbl = UILabel()
        numberLbl.frame = CGRect(x:0, y:0, width:alertView.frame.size.width, height:50)
        numberLbl.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        numberLbl.layer.cornerRadius = 5
        numberLbl.text = "VERIFY OTP"
        numberLbl.font =  UIFont(name:"Helvetica-Medium", size: 16)
        numberLbl.textAlignment = .center
        numberLbl.textColor = UIColor.white
        otpAlertView.addSubview(numberLbl)
        
        enterOtpTF.frame = CGRect(x:10, y:70, width:otpAlertView.frame.size.width-20, height:46)
        enterOtpTF.delegate = self
        enterOtpTF.placeholder = "Enter OTP"
        enterOtpTF.font = UIFont(name: "Helvetica", size: 16)
        enterOtpTF.keyboardType=UIKeyboardType.numberPad
        enterOtpTF.autocorrectionType = UITextAutocorrectionType.no
        otpAlertView.addSubview(enterOtpTF)
        
        let lineLbl = UILabel()
        lineLbl.frame = CGRect(x:10, y:enterOtpTF.frame.origin.y+46, width:alertView.frame.size.width-20, height:1)
        lineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        otpAlertView.addSubview(lineLbl)
        
        cancelOtpBtn.frame = CGRect(x:10, y:enterOtpTF.frame.origin.y+70, width:alertView.frame.size.width/3-15, height:40)
        cancelOtpBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cancelOtpBtn.setTitle("Cancel", for: .normal)
        cancelOtpBtn.setTitleColor(UIColor.darkGray, for: .normal)
        cancelOtpBtn.addTarget(self, action: #selector(ProfileViewController.cancelOTPButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelOtpBtn.layer.cornerRadius = 2
        otpAlertView.addSubview(cancelOtpBtn)
        
        resendBtn.frame = CGRect(x:cancelOtpBtn.frame.origin.x+cancelOtpBtn.frame.size.width+10, y:cancelOtpBtn.frame.origin.y, width:cancelOtpBtn.frame.size.width, height:40)
        resendBtn.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        resendBtn.setTitle("Resend", for: .normal)
        resendBtn.setTitleColor(UIColor.white, for: .normal)
        resendBtn.addTarget(self, action: #selector(ProfileViewController.resendButtonAction(_:)), for: UIControlEvents.touchUpInside)
        resendBtn.layer.cornerRadius = 2
        otpAlertView.addSubview(resendBtn)
        
        verifyBtn.frame = CGRect(x:resendBtn.frame.origin.x+cancelOtpBtn.frame.size.width+10, y:cancelOtpBtn.frame.origin.y, width:cancelOtpBtn.frame.size.width, height:40)
        verifyBtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        //registerButton.setTitleColor(UIColor.white, for: .normal)
        verifyBtn.backgroundColor=#colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        verifyBtn.setTitle("Done", for: .normal)
        verifyBtn.addTarget(self, action: #selector(ProfileViewController.verifyButtonAction(_:)), for: UIControlEvents.touchUpInside)
        verifyBtn.layer.cornerRadius = 2
        otpAlertView.addSubview(verifyBtn)
    }
    func cancelOTPButtonAction(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.enterOtpTF.text! = ""
        self.otpPopUpView.removeFromSuperview()
        self.popUpView.removeFromSuperview()
    }
    func resendButtonAction(_ sender : UIButton)
    {
        self.view.endEditing(true)
        let baseURL: String  = String(format: "%@resend_otp_mobile/",Constants.mainURL)
        let params = "user_id=\(otpID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    AFWrapperClass.alert(Constants.applicationName, message: "OTP send successful", view: self)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "OTP not send Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
     }
    func verifyButtonAction(_ sender : UIButton)
    {
        self.view.endEditing(true)
        if (enterOtpTF.text?.isEmpty)!
        {
           AFWrapperClass.alert(Constants.applicationName, message: "Please enter OTP", view: self)
        }
        else{
        
        let baseURL: String  = String(format: "%@verify_otp_mobile/",Constants.mainURL)
        let params = "user_id=\(otpID)&otp=\(enterOtpTF.text!)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    AFWrapperClass.alert(Constants.applicationName, message: "Mobile number updated successful Please login.", view: self)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "OTP not verified Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
        }
    }
  
   // MARK: Change PassWord Method:
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        self.changePassWordViewMethod()
    }
    @objc private func changePassWordViewMethod () -> Void
    {
        
        changePWpopUpView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        changePWpopUpView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view .addSubview(changePWpopUpView)
        changePWpopUpView.contentSize = CGSize(width:self.view.frame.size.width , height: self.view.frame.size.height)
        
        pwAlertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-150, width:self.view.frame.size.width-60, height:300)
        pwAlertView.backgroundColor = UIColor.white
        pwAlertView.layer.cornerRadius = 5
        changePWpopUpView.addSubview(pwAlertView)
        
        let numberLbl = UILabel()
        numberLbl.frame = CGRect(x:0, y:0, width:pwAlertView.frame.size.width, height:50)
        numberLbl.backgroundColor = #colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        numberLbl.layer.cornerRadius = 5
        numberLbl.text = "CHANGE PASSWORD"
        numberLbl.font =  UIFont(name:"Helvetica-Medium", size: 16)
        numberLbl.textAlignment = .center
        numberLbl.textColor = UIColor.white
        pwAlertView.addSubview(numberLbl)
        
        currentPWTF.frame = CGRect(x:10, y:60, width:pwAlertView.frame.size.width-20, height:46)
        currentPWTF.delegate = self
        currentPWTF.placeholder = "Current Password"
        currentPWTF.font = UIFont(name: "Helvetica", size: 16)
        currentPWTF.placeHolderColor=UIColor.darkGray
        currentPWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        currentPWTF.lineColor=UIColor.clear
        currentPWTF.selectedLineColor=UIColor.clear
        currentPWTF.isSecureTextEntry = true
        currentPWTF.autocorrectionType = UITextAutocorrectionType.no
        pwAlertView.addSubview(currentPWTF)
        
        let curntLineLbl = UILabel()
        curntLineLbl.frame = CGRect(x:10, y:currentPWTF.frame.origin.y+46, width:pwAlertView.frame.size.width-20, height:1)
        curntLineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pwAlertView.addSubview(curntLineLbl)
        
        changePWTF.frame = CGRect(x:10, y:currentPWTF.frame.origin.y+56, width:pwAlertView.frame.size.width-20, height:46)
        changePWTF.delegate = self
        changePWTF.placeholder = "New Password"
        changePWTF.font = UIFont(name: "Helvetica", size: 16)
        changePWTF.placeHolderColor=UIColor.darkGray
        changePWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        changePWTF.lineColor=UIColor.clear
        changePWTF.selectedLineColor=UIColor.clear
        changePWTF.isSecureTextEntry = true
        changePWTF.autocorrectionType = UITextAutocorrectionType.no
        pwAlertView.addSubview(changePWTF)
        
        let pwLineLbl = UILabel()
        pwLineLbl.frame = CGRect(x:10, y:changePWTF.frame.origin.y+46, width:pwAlertView.frame.size.width-20, height:1)
        pwLineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pwAlertView.addSubview(pwLineLbl)
        
        confirmPWTF.frame = CGRect(x:10, y:changePWTF.frame.origin.y+56, width:pwAlertView.frame.size.width-20, height:46)
        confirmPWTF.delegate = self
        confirmPWTF.placeholder = "Confirm New Password"
        confirmPWTF.font = UIFont(name: "Helvetica", size: 16)
        confirmPWTF.placeHolderColor=UIColor.darkGray
        confirmPWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.07232465595, green: 0.5733270049, blue: 0.6467688084, alpha: 1)
        confirmPWTF.lineColor=UIColor.clear
        confirmPWTF.selectedLineColor=UIColor.clear
        confirmPWTF.isSecureTextEntry = true
        confirmPWTF.autocorrectionType = UITextAutocorrectionType.no
        pwAlertView.addSubview(confirmPWTF)
        
        let confimLineLbl = UILabel()
        confimLineLbl.frame = CGRect(x:10, y:confirmPWTF.frame.origin.y+46, width:pwAlertView.frame.size.width-20, height:1)
        confimLineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pwAlertView.addSubview(confimLineLbl)
        
        cancelPWbtn.frame = CGRect(x:pwAlertView.frame.size.width/2-125, y:confirmPWTF.frame.origin.y+66, width:120, height:40)
        cancelPWbtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cancelPWbtn.setTitle("CANCEL", for: .normal)
        cancelPWbtn.setTitleColor(UIColor.darkGray, for: .normal)
        cancelPWbtn.addTarget(self, action: #selector(ProfileViewController.cancelPasswordButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelPWbtn.layer.cornerRadius = 2
        pwAlertView.addSubview(cancelPWbtn)
        
        
        donePWbtn.frame = CGRect(x:pwAlertView.frame.size.width/2+5, y:confirmPWTF.frame.origin.y+66, width:120, height:40)
        donePWbtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        //registerButton.setTitleColor(UIColor.white, for: .normal)
        donePWbtn.backgroundColor=#colorLiteral(red: 0.1423749924, green: 0.574128449, blue: 0.6473506093, alpha: 1)
        donePWbtn.setTitle("CHANGE", for: .normal)
        donePWbtn.addTarget(self, action: #selector(ProfileViewController.donePasswordButtonAction(_:)), for: UIControlEvents.touchUpInside)
        donePWbtn.layer.cornerRadius = 2
        pwAlertView.addSubview(donePWbtn)

        
    }
    
    func cancelPasswordButtonAction(_ sender : UIButton)
    {
        self.view.endEditing(true)
        currentPWTF.text = ""
        changePWTF.text = ""
        confirmPWTF.text = ""
        changePWpopUpView.removeFromSuperview()
    }
    func donePasswordButtonAction(_ sender : UIButton)
    {
        
        var message = String()
        if (currentPWTF.text?.isEmpty)!
        {
            message = "Please enter current password"
        }
        else if (changePWTF.text?.characters.count)! < 6
        {
            message = "Password sould be minimum 6 characters"
        }
        else if !(changePWTF.text == confirmPWTF.text)
        {
            message = "Confirm password doesn't match please try again"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.passwordChangeAPImethod()
        }
    }
    
    
    func passwordChangeAPImethod () -> Void
    {
        self.view.endEditing(true)
        let baseURL: String  = String(format: "%@change_password/",Constants.mainURL)
        let params = "user_id=\(userID)&current_password=\(currentPWTF.text!)&new_password=\(changePWTF.text!)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.currentPWTF.text = ""
                    self.changePWTF.text = ""
                    self.confirmPWTF.text = ""
                    self.changePWpopUpView.removeFromSuperview()
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message:"Current password does not matched Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
        
    }
 
  // MARK: Google Places:  
    
    @IBAction func cityButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        self.cityTF.text! = place.name
        self.postalCodeTF.text = " "
        
        let address = place.name
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if placemarks != nil
            {
            let placemar: CLPlacemark = (placemarks?[0])!
            let loc :CLLocation = placemar.location!
            self.coordinate = loc.coordinate
        //print(self.coordinate.latitude,self.coordinate.longitude)
            self.getPostalCode()
            }
        }
    }
    
    func getPostalCode()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            if ((error) != nil)
            {
              //print(error?.localizedDescription ?? NSError())
            }
            else{
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if placeMark.postalCode != nil
                {
                    let pCode = placeMark.postalCode! as String
                    self.postalCodeTF.text! = pCode
                }
              }
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
         print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
// MARK: TextField Delegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == mobileTF {
        alertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-200, width:self.view.frame.size.width-60, height:220)
        }
        else if textField == enterOtpTF {
            otpAlertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-200, width:self.view.frame.size.width-60, height:220)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField == mobileTF {
         alertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-120, width:self.view.frame.size.width-60, height:220)
        }
       else if textField == enterOtpTF {
            otpAlertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-120, width:self.view.frame.size.width-60, height:220)
        }
    }
    
      func textField(_ textField: UITextField, shouldChangeCharactersIn shouldChangeCharactersInRangerange: NSRange, replacementString string: String)-> Bool
    {
        let newString = ((textField.text)! as NSString).replacingCharacters(in: shouldChangeCharactersInRangerange, with: string)
        let newLength = newString.characters.count
        if (textField == emergencyContactTF)
        {
            if (newLength == 12)
            {
            emergencyContactTF.resignFirstResponder()
            return false
            }
        }
        else if (textField == mobileTF)
        {
            if (newLength == 12)
            {
                mobileTF.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    
 // MARK: LogOut
    @IBAction func logOutButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Kinder Drop", message: "Do you want Logout?", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
            self.LogOutAPImethod()
            alertController.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert :UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    func LogOutAPImethod () -> Void
    {
        let baseURL: String  = String(format: "%@userlogout/",Constants.mainURL)
        let params = "user_id=\(userID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    UserDefaults.standard.removeObject(forKey:"saveUserID")
                    UserDefaults.standard.removeObject(forKey:"success")
                    UserDefaults.standard.synchronize()
                    //UserDefaults.standard.set("UnSuccess", forKey: "success")
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message:"Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
 // MARK: Terms & Conditions
    @IBAction func termsConditionBtnAction(_ sender: Any) {
        
        let baseURL: String  = String(format: "%@termscondition/",Constants.mainURL)
        let params = ""
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsVC") as? TermsAndConditionsVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.displayLblStr = "Terms & Conditions"
                    myVC?.hiddenStr = "YES"
                    myVC?.textStr = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "text") as! String
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message:"Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
// MARK: Privacy Policy
    
    @IBAction func privacyBtnAction(_ sender: Any) {
        let baseURL: String  = String(format: "%@privacypolicy/",Constants.mainURL)
        let params = ""
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsVC") as? TermsAndConditionsVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.displayLblStr = "Privacy policy"
                    myVC?.hiddenStr = "YES"
                     myVC?.textStr = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "text") as! String
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message:"Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
   
    // MARK: Notifications:
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
                        self.badgeCountLbl.isHidden = true
                    }else{
                        self.badgeCountLbl.isHidden = false
                        self.badgeCountLbl.text! = countStr
                    }
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "No DayCare Found", view: self)
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
