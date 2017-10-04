//
//  LaunchAnimateVC.swift
//  KinderDrop
//
//  Created by think360 on 20/06/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class LaunchAnimateVC: UIViewController {
    
    private var count: Int = 0
    private var maxBlind: Int = 10

    
    @IBOutlet weak var splashImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startAnim()
        
//        AFWrapperClass.fadeIn(view: splashImage)
//        UIView.animate(withDuration: 0.8,
//                                   delay: 1.0,
//                                   options: [UIViewAnimationOptions.curveLinear,
//                                             UIViewAnimationOptions.repeat,
//                                             UIViewAnimationOptions.autoreverse],
//                                   animations: { self.splashImage.alpha = 1.0 },
//                                   completion: nil)
        
        Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.gotomainmenuview), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func startAnim ()
    {
        let animDuration: CGFloat = 0.3
        UIView.animate(withDuration: TimeInterval(animDuration), animations: {() -> Void in
            self.splashImage.alpha = 0.0
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: TimeInterval(animDuration), animations: {() -> Void in
                self.splashImage.alpha = 1.0
            }, completion: {(_ finished: Bool) -> Void in
                if self.count < self.maxBlind {
                    self.startAnim()
                    self.count += 1
                }
            })
        })
    }
    
    func gotomainmenuview(_ theTimer: Timer) {
        let userID = UserDefaults.standard.object(forKey: "success")
        
        if (userID == nil)
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            self.navigationController?.pushViewController(myVC!, animated: false)
            UserDefaults.standard.set("UnSuccess", forKey: "success")
        }else
        {
            if UserDefaults.standard.object(forKey: "success") as! String == "LoginSuccess"
            {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
            self.navigationController?.pushViewController(myVC!, animated: true)
            }
            else
            {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            self.navigationController?.pushViewController(myVC!, animated: false)
                UserDefaults.standard.set("UnSuccess", forKey: "success")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
