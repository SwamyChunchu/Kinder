//
//  ChildTableCell.swift
//  KinderDrop
//
//  Created by amit on 4/27/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ChildTableCell: UITableViewCell {

    @IBOutlet weak var childImageVW: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
