//
//  ReviewTableCell.swift
//  KinderDrop
//
//  Created by amit on 4/13/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ReviewTableCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var textRvwLabel: UILabel!
    @IBOutlet weak var nameLabelRvw: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var dateLblRvw: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
