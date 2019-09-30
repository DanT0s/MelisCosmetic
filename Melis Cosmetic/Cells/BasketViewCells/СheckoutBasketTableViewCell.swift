//
//  СheckoutBasketTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/18/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class CheckoutBasketTableViewCell: UITableViewCell {

   
    @IBOutlet weak var checkoutButtonLabel: UIButton!
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      checkoutButtonLabel.layer.cornerRadius = 10
        checkoutButtonLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
