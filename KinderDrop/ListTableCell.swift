//
//  ListTableCell.swift
//  KinderDrop
//
//  Created by amit on 4/6/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ListTableCell: UITableViewCell {
    
    @IBOutlet weak var locationImg: UILabel!
    @IBOutlet weak var datCareImage: UIImageView!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var navigationButton: UIButton!
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
