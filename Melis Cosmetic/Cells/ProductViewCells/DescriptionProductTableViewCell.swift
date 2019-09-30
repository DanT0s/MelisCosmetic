//
//  DesqriptionProductTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/17/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class DescriptionProductTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutProductLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
