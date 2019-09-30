//
//  ProductBasketTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/18/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class ProductBasketTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productManagerLabel: UIButton!
    @IBAction func productManagerButton(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
