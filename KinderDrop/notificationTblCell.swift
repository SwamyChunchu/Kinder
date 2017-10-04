//
//  notificationTblCell.swift
//  KinderDrop
//
//  Created by amit on 4/18/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class notificationTblCell: UITableViewCell {

    @IBOutlet weak var imageViewBkng: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var bookingStatusLbl: UILabel!
    
    
    @IBOutlet weak var feedBackbtn: UIButton!
    
    @IBOutlet weak var feedBtnHightCnstrnt: NSLayoutConstraint!
    
    
     override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
