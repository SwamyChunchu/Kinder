//
//  TSearchableViewCell.swift
//  KinderDrop
//
//  Created by amit on 4/21/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class TSearchableViewCell: UITableViewCell {

   @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayCareLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
