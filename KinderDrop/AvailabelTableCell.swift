//
//  AvailabelTableCell.swift
//  KinderDrop
//
//  Created by amit on 4/14/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class AvailabelTableCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var slotLabel: UILabel!
    @IBOutlet weak var bookNowAvailBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
