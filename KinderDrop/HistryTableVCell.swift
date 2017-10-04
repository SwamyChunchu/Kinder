//
//  HistryTableVCell.swift
//  KinderDrop
//
//  Created by amit on 4/7/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class HistryTableVCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageVwhistry: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adderssLabel: UILabel!
    @IBOutlet weak var bookNowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
