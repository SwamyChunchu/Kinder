//
//  AddChildVC.swift
//  KinderDrop
//
//  Created by amit on 4/11/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

class AddChildVC: UIViewController,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,UITextFieldDelegate
{
    @IBOutlet weak var nameTF: ACFloatingTextfield!
    @IBOutlet weak var ageTF: ACFloatingTextfield!
    @IBOutlet weak var alergyTF: ACFloatingTextfield!
    @IBOutlet weak var specialInstrctTF: ACFloatingTextfield!
    @IBOutlet weak var foodRestrictionTF: ACFloatingTextfield!
    @IBOutlet weak var commentTF: ACFloatingTextfield!
    
    @IBOutlet weak var emergencyCntct: ACFloatingTextfield!
    
    @IBOutlet weak var friendlyButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var aggressiveButton: UIButton!
    @IBOutlet weak var shyButton: UIButton!
    @IBOutlet weak var coOperativeButton: UIButton!
    @IBOutlet weak var easyGoingButton: UIButton!
    
    @IBOutlet weak var useWrdsButton: UIButton!
    @IBOutlet weak var aggressiveSpeechButton: UIButton!
    @IBOutlet weak var speakSentncButton: UIButton!
    
    @IBOutlet weak var canDressByHimButton: UIButton!
    @IBOutlet weak var toilettrained: UIButton!
    @IBOutlet weak var caneatByHimButton: UIButton!
    
    @IBOutlet weak var allDayDiaperButton: UIButton!
    @IBOutlet weak var naptimeOnly: UIButton!
    @IBOutlet weak var overTimeOnlyButton: UIButton!
    
    @IBOutlet weak var notReqDiaperBtn: UIButton!
    
    
    
    
    
    @IBOutlet weak var childProfileImageVW: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var generalTemperamenrStr = String()
    var speechDevlpStr = String()
    var selfSkillsStr = String()
    var diaperStr = String()
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    var userID = String()
    
    var friendlyString = String()
    var activeString = String()
    var aggressiveString = String()
    var shyString = String()
    var coOperativeString = String()
    var easyGoingString = String()
    
    var useWordsStr = String()
    var speechInSentnceStr = String()
    var aggresuveSpchStr = String()
    
    var canDrsByHimStr = String()
    var toiletTrainedStr = String()
    var canEatByHimStr = String()
    
    var allDayStr = String()
    var napTimeonlyStr = String()
    var overNitOnlyStr = String()
    var notReqDprStr = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
        imagePicker.delegate = self
        
        generalTemperamenrStr = ""
        speechDevlpStr = ""
        selfSkillsStr = ""
        diaperStr = ""
    
        let url = NSURL(string:"")
        self.childProfileImageVW.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "profilePlaceHolder"))
        
        friendlyButton.isSelected = true
        activeButton.isSelected = true
        aggressiveButton.isSelected = true
        shyButton.isSelected = true
        coOperativeButton.isSelected = true
        easyGoingButton.isSelected = true
        
        useWrdsButton.isSelected = true
        speakSentncButton.isSelected = true
        aggressiveSpeechButton.isSelected = true
        
        canDressByHimButton.isSelected = true
        toilettrained.isSelected = true
        caneatByHimButton.isSelected = true
        
        allDayDiaperButton.isSelected = true
        naptimeOnly.isSelected = true
        overTimeOnlyButton.isSelected = true
        
//        emergencyCntct.delegate = self
}
    
   //MARK:  General Temperament  ButtonActions:
    @IBAction func friendlyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            friendlyButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            friendlyString = "Friendly Outgoing"
        } else {
            friendlyString = ""
            friendlyButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func activeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            activeButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            activeString = "Active"
        } else {
            activeString = ""
            activeButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func aggressiveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            aggressiveButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            aggressiveString = "Aggressive"
        } else {
            aggressiveString = ""
            aggressiveButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func shyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            shyButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            shyString = "Shy"
        } else {
            shyString = ""
            shyButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func coOprativeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            coOperativeButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            coOperativeString = "Co-operative"
        } else {
            coOperativeString = ""
            coOperativeButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func easyGoingButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            easyGoingButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            easyGoingString = "Easy-going"
        } else {
            easyGoingString = ""
            easyGoingButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    
    //MARK:  Speech Development  ButtonActions:
    @IBAction func useWrdsOnlyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            useWrdsButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            useWordsStr = "Use words only"
        } else {
            useWordsStr = ""
            useWrdsButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func speakInSentncButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        if sender.isSelected {
            speakSentncButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            speechInSentnceStr = "Speak in Sentences"
        } else {
            speechInSentnceStr = ""
            speakSentncButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func aggressiveSpeechButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            aggressiveSpeechButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            aggresuveSpchStr = "Aggressive"
        } else {
            aggresuveSpchStr = ""
            aggressiveSpeechButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    
   //MARK:  Self Skills  ButtonActions:
    @IBAction func canDressByHimButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            canDressByHimButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            canDrsByHimStr = "Can dress by him/herself"
        } else {
            canDrsByHimStr = ""
            canDressByHimButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func toiletTrained(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            toilettrained.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            toiletTrainedStr = "Toilet Trained"
        } else {
            toiletTrainedStr = ""
            toilettrained.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func eatByHimButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            caneatByHimButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            canEatByHimStr = "Can eat by him/herself"
        } else {
            canEatByHimStr = ""
            caneatByHimButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    //MARK:  Diapers  ButtonActions:
    @IBAction func allDayDiapersButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            allDayDiaperButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            allDayStr = "All Day"
        } else {
            allDayStr = ""
            allDayDiaperButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func naptimeOnlyDiapersButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            naptimeOnly.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            napTimeonlyStr = "Naptime only"
        } else {
            napTimeonlyStr = ""
            naptimeOnly.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
    }
    @IBAction func overNightDiapersButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            overTimeOnlyButton.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            overNitOnlyStr = "Overnight Only"
        } else {
            overNitOnlyStr = ""
            overTimeOnlyButton.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }
}
    
    @IBAction func notReqDiaperBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.isSelected {
            notReqDiaperBtn.setImage(#imageLiteral(resourceName: "CheckBokRight"), for: UIControlState.normal)
            sender.isSelected = false
            notReqDprStr = "Not required to wear diapers"
        } else {
            notReqDprStr = ""
            notReqDiaperBtn.setImage(#imageLiteral(resourceName: "UnChkSquare"), for: UIControlState.normal)
            sender.isSelected = true
        }

    }
    
    
    //MARK:  Camera  ButtonActions:
    @IBAction func cameraButtonAction(_ sender: Any) {
        self.view.endEditing(true)
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
            popOverPresentationController.sourceView                = cameraButton
            popOverPresentationController.sourceRect                = cameraButton.bounds
            popOverPresentationController.permittedArrowDirections  = UIPopoverArrowDirection.any
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.childProfileImageVW.image = currentSelectedImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
//MARK:  SaveProfile  ButtonActions:
@IBAction func saveProfileButtonAction(_ sender: Any)
  {
    let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 1)
    let temperArray = NSMutableArray()
    if friendlyString.characters.count > 0 {
        temperArray.add(friendlyString)
    }
    if activeString.characters.count > 0 {
        temperArray.add(activeString)
    }
    if aggressiveString.characters.count > 0 {
        temperArray.add(aggressiveString)
    }
    if shyString.characters.count > 0 {
        temperArray.add(shyString)
    }
    if coOperativeString.characters.count > 0 {
        temperArray.add(coOperativeString)
    }
    if easyGoingString.characters.count > 0 {
        temperArray.add(easyGoingString)
    }
    
    let speechDevArray = NSMutableArray()
    if useWordsStr.characters.count > 0 {
        speechDevArray.add(useWordsStr)
    }
    if speechInSentnceStr.characters.count > 0 {
        speechDevArray.add(speechInSentnceStr)
    }
    if aggresuveSpchStr.characters.count > 0 {
        speechDevArray.add(aggresuveSpchStr)
    }
    
    let selfSkilsArray = NSMutableArray()
    if canDrsByHimStr.characters.count > 0 {
        selfSkilsArray.add(canDrsByHimStr)
    }
    if toiletTrainedStr.characters.count > 0 {
        selfSkilsArray.add(toiletTrainedStr)
    }
    if canEatByHimStr.characters.count > 0 {
        selfSkilsArray.add(canEatByHimStr)
    }
    
    let dipersArray = NSMutableArray()
    if allDayStr.characters.count > 0 {
        dipersArray.add(allDayStr)
    }
    if napTimeonlyStr.characters.count > 0 {
        dipersArray.add(napTimeonlyStr)
    }
    if overNitOnlyStr.characters.count > 0 {
        dipersArray.add(overNitOnlyStr)
    }
    if notReqDprStr.characters.count > 0 {
        dipersArray.add(notReqDprStr)
    }
    
    var message = String()
    if (nameTF.text?.isEmpty)!
    {
        nameTF.becomeFirstResponder()
        message = "Please enter child name."
    }
    else if (ageTF.text?.isEmpty)!
    {
        ageTF.becomeFirstResponder()
        message = "Please enter child age."
    }
    else if (alergyTF.text?.isEmpty)!
    {
        alergyTF.becomeFirstResponder()
        message = "Please type child Alergy."
    }
    else if (emergencyCntct.text?.isEmpty)!
    {
        emergencyCntct.becomeFirstResponder()
        message = "Please enter emergency contact."
    }
    else if (foodRestrictionTF.text?.isEmpty)!
    {
        foodRestrictionTF.becomeFirstResponder()
        message = "Please type child food restrictions."
    }
    
    else if temperArray.count == 0
    {
        message = "Please select child general temperament."
    }
    else if speechDevArray.count == 0
    {
        message = "Please select child speech development."
    }
    else if selfSkilsArray.count == 0
    {
        message = "Please select child self skills."
    }
    else if dipersArray.count == 0
    {
        message = "Please select child diapers."
    }
    else if (commentTF.text?.isEmpty)!
    {
        commentTF.becomeFirstResponder()
        message = "Please type comment."
    }
    else  if imageData == nil {
        
         message = "Please upload child image."
    }
    
    if message.characters.count > 1 {
        AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
    }else{
        generalTemperamenrStr = temperArray.componentsJoined(by: ",")
        
        speechDevlpStr = speechDevArray.componentsJoined(by: ",")
        
        selfSkillsStr = selfSkilsArray.componentsJoined(by: ",")
        
        diaperStr = dipersArray.componentsJoined(by: ",")
        self.addChildrenAPIMethod ()
    }
}
    
  func addChildrenAPIMethod () -> Void
    {
       self.view.endEditing(true)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 0.5)
        if imageData == nil {
            let imgData: Data? = UIImageJPEGRepresentation(self.childProfileImageVW.image!, 0.5)
            self.currentSelectedImage = UIImage(data: imgData! as Data)!
            //currentSelectedImage = UIImage(named: "profilePlaceHolder")!
        }
        let parameters = ["userid"                 :userID,
                          "name"                    :nameTF.text!,
                          "age"                     :ageTF.text!,
                          "alergy"                  :alergyTF.text!,
                          "special_instruction"     :specialInstrctTF.text!,
                          "reason"                  :foodRestrictionTF.text!,
                          "general_temprament"      :generalTemperamenrStr,
                          "speech_development"      :speechDevlpStr,
                          "self_skill"              :selfSkillsStr,
                          "diapers"                 :diaperStr,
                          "comment"                 :commentTF.text!,
                          "emergency_contact"       :emergencyCntct.text!
                          ] as [String : String]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let image = self.currentSelectedImage
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "profilepic", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:String(format: "%@addchild/",Constants.mainURL))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.result.isSuccess
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        if ((response.result.value as! NSDictionary).object(forKey: "status") as! Bool) == true
                        {
                            _ = self.navigationController?.popViewController(animated: true)
                        AFWrapperClass.alert(Constants.applicationName, message: "Child Added Successfully", view: self)
                        }else{
                          AFWrapperClass.alert(Constants.applicationName, message: "Child not Added Please try again", view: self)
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
    
   //MARK: Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn shouldChangeCharactersInRangerange: NSRange, replacementString string: String)-> Bool
        
    {
        let newString = ((textField.text)! as NSString).replacingCharacters(in: shouldChangeCharactersInRangerange, with: string)
        
        let newLength = newString.characters.count
        
        if (textField == emergencyCntct)
        {
            if (newLength == 12)
            {
                emergencyCntct.resignFirstResponder()
                return false
            }
            
        }
        return true
    }
 
    
    
    
    
 @IBAction func backButtonAction(_ sender: Any) {
      _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

      
}
