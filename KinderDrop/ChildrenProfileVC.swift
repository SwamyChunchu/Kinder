//
//  ChildrenProfileVC.swift
//  KinderDrop
//
//  Created by amit on 4/11/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore


class ChildrenProfileVC: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate
{

    
    @IBOutlet weak var childProfileImageVW: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    
    
    @IBOutlet weak var nameTF: ACFloatingTextfield!
    @IBOutlet weak var ageTF: ACFloatingTextfield!
    @IBOutlet weak var generalTemparmntTF: ACFloatingTextfield!
    @IBOutlet weak var sppechDevlpTF: ACFloatingTextfield!
    @IBOutlet weak var selfSkillTF: ACFloatingTextfield!
    @IBOutlet weak var diaperTF: ACFloatingTextfield!
    
 
    @IBOutlet weak var cameraButton: UIButton!
    
    var childID = String()
    var userID = String()
    var  dataDic = NSDictionary()
    var dataChildAry = NSArray()
    var childNameAry = NSArray()
    var childImageAry = NSArray()
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTF.delegate=self
        ageTF.delegate=self
        generalTemparmntTF.delegate=self
        sppechDevlpTF.delegate=self
        selfSkillTF.delegate=self
        diaperTF.delegate=self
        
        imagePicker.delegate = self
        
        userID = UserDefaults.standard.value(forKey: "saveUserID") as! String
        
        self.childProfileAPIMethod()
    }
    
  
    
    func childProfileAPIMethod () -> Void
    {
        
        
        let baseURL: String  = String(format: "%@particular_childhistory/",Constants.mainURL)
        let params = "id=\(childID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                
                AFWrapperClass.svprogressHudDismiss(view: self)
                
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
                    self.dataDic = responceDic.object(forKey: "data") as! NSDictionary
                    
                    self.profileName.text! = (self.dataDic.object(forKey: "child_name") as? String)!
                    self.nameTF.text! = (self.dataDic.object(forKey: "child_name") as? String)!
                    self.ageTF.text! = (self.dataDic.object(forKey: "age") as? String)!
                    self.generalTemparmntTF.text! = (self.dataDic.object(forKey: "general_temprament") as? String)!
                    self.sppechDevlpTF.text! = (self.dataDic.object(forKey: "speech_development") as? String)!
                    
                    self.selfSkillTF.text! = (self.dataDic.object(forKey: "self_skill") as? String)!
                     self.diaperTF.text! = (self.dataDic.object(forKey: "diapers") as? String)!
                    
                    let imageURL: String = (self.dataDic.object(forKey: "profilepic") as? String)!
                    let url = NSURL(string:imageURL)
                    self.childProfileImageVW.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "profilePlaceHolder"))
                    
                    //                    let imgData: Data? = UIImageJPEGRepresentation(self.profileImage.image!, 1)
                    //                    self.currentSelectedImage = UIImage(data: imgData! as Data)!
                    //self.currentSelectedImage=self.profileImage.image!
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

    
    
    
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        
        nameTF.becomeFirstResponder()
        
        nameTF.isEnabled=true
        ageTF.isEnabled=true
//        generalTemparmntTF.isEnabled=true
//        sppechDevlpTF.isEnabled=true
//        selfSkillTF.isEnabled=true
//        diaperTF.isEnabled=true
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        
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
    
    
    
    func image(withReduce imageName: UIImage, scaleTo newsize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
        imageName.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newsize.width), height: CGFloat(newsize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        currentSelectedImage = self.image(withReduce: currentSelectedImage, scaleTo: CGSize(width: CGFloat(40), height: CGFloat(40)))
        self.childProfileImageVW.image = currentSelectedImage
        
        // self.updateProfileAPIMethod()
        
        //        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        //        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        //        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        //        if let dirPath          = paths.first
        //        {
        //            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("ImageSam.png")
        //            let image    = UIImage(contentsOfFile: imageURL.path)
        
        // }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        dismiss(animated: true, completion: nil)
    }
    
    

    
    
    @IBAction func saveProfileButtonAction(_ sender: Any) {
        
       // let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 1)
        
        
        var message = String()
        
        if (nameTF.text?.isEmpty)!
        {
            message = "Please enter Name."
        }
         else if (ageTF.text?.isEmpty)!
        {
            message = "Please enter age."
        }
//        else  if imageData == nil {
//            
//            message = "Please upload child image."
//        }
//        else if (generalTemparmntTF.text?.isEmpty)!
//        {
//            message = "Please enter general temperament"
//        }
//        else if (sppechDevlpTF.text?.isEmpty)!
//        {
//            message = "Please enter speech development"
//        }
//        else if (selfSkillTF.text?.isEmpty)!
//        {
//            message = "Please enter self skills"
//        }
//        else if (diaperTF.text?.isEmpty)!
//        {
//            message = "Please enter diaper usage"
//        }
        
        
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
            
        }else{
            
            self.updateChildInfoAPIMethod ()
        }
        
}
    
    
    func updateChildInfoAPIMethod () -> Void
    {
        
        
        self.view.endEditing(true)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 1)
        if imageData == nil {
            
            let imgData: Data? = UIImageJPEGRepresentation(self.childProfileImageVW.image!, 1)
            self.currentSelectedImage = UIImage(data: imgData! as Data)!
            //currentSelectedImage = UIImage(named: "profilePlaceHolder")!
        }
        
        let parameters = ["id"                       :childID,
                          "name"                     :nameTF.text!,
                          "age"                      :ageTF.text!,
                          "alergy"                   :"",
                          "alespecial_instructionrgy":"",
                          "reason"                   :"",
                          "general_temprament"       :"",
                          "speech_development"       :"",
                          "self_skill"               :"",
                          "diapers"                  :"",
                          "comment"                  :""
                                                         ] as [String : String]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let image = self.currentSelectedImage
            
            multipartFormData.append(UIImageJPEGRepresentation(image, 1)!, withName: "profilepic", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
            
            for (key, value) in parameters {
                
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                
            }
            
            
            //String(format: "%@user_history/",Constants.mainURL)useredit
        }, to:String(format: "%@childedit/",Constants.mainURL))
            
        { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                })
                
                upload.responseJSON { response in
                    
                    if response.result.isSuccess
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        self.childProfileAPIMethod()
                        
                        self.nameTF.isEnabled = false
                         self.ageTF.isEnabled = false
//                        self.generalTemparmntTF.isEnabled = false
//                        self.sppechDevlpTF.isEnabled = false
//                        self.selfSkillTF.isEnabled = false
//                        self.diaperTF.isEnabled = false
                        
                        
                        AFWrapperClass.alert(Constants.applicationName, message: "Profile Update Successfully", view: self)
                        
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
    
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
