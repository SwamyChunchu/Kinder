//
//  BannerViewVC.swift
//  KinderDrop
//
//  Created by think360 on 19/06/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import LCBannerView
import SDWebImage

class BannerViewVC: UIViewController,LCBannerViewDelegate
{
     var imagesArrayFul = NSArray()
     @IBOutlet weak var imageViewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.imagesArrayFul.count == 0
        {
            self.imagesArrayFul = ["http://think360.in/kindr/api/uploads/uploadedPic-255962348.471.jpeg"]
            self.perform(#selector(BannerViewVC.showBannerView), with: nil, afterDelay: 0.02)
        }else{
            self.perform(#selector(BannerViewVC.showBannerView), with: nil, afterDelay: 0.02)
        }

    }
    func showBannerView()
    {
        let imagesDataArray = NSMutableArray()
        for i in 0..<imagesArrayFul.count
        {
            let image: String = imagesArrayFul.object(at: i) as! String
            //as! NSDictionary).object(forKey: "link") as! String
            let image1 = image.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
            imagesDataArray.add(image1 as Any)
        }
        
        if UI_USER_INTERFACE_IDIOM()  == .phone
        {
             let banner = LCBannerView.init(frame: CGRect(x: 0, y: self.imageViewBack.frame.size.height/2-140, width: self.imageViewBack.frame.size.width, height: 280), delegate: self, imageURLs: (imagesArrayFul as NSArray) as! [Any], placeholderImage:"PlaceHolderImageLoading", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
            banner?.clipsToBounds = true
            banner?.contentMode = .scaleAspectFit
            imageViewBack.addSubview(banner!)
        }else
        {
            let banner = LCBannerView.init(frame: CGRect(x: 0, y: self.imageViewBack.frame.size.height/2-230, width: self.imageViewBack.frame.size.width, height: 460), delegate: self, imageURLs: (imagesArrayFul as NSArray) as! [Any], placeholderImage:"PlaceHolderImageLoading", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
            banner?.clipsToBounds = true
            banner?.contentMode = .scaleAspectFit
            imageViewBack.addSubview(banner!)
        }
        
        
        
    }

    @IBAction func backButtonAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: false)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
