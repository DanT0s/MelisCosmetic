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
    @IBOutlet weak var stepper: UIStepper!
    
    var stepperValue: Int?
    
    @IBAction func productStepper(_ sender: UIStepper) {
        stepperValue = Int(stepper.value)
        productNumberQuantityLabel.text = stepperValue?.description
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
