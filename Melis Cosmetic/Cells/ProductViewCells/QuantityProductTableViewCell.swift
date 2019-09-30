//
//  QuantityTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/17/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class QuantityProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productNumberQuantityLabel: UILabel!
    @IBAction func productStepper(_ sender: UIStepper) {
        productNumberQuantityLabel.text = String(format: "%.f",(sender.value))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
