//
//  SumBasketTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/18/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class SumBasketTableViewCell: UITableViewCell {

    @IBOutlet weak var goodsInOrderLabel: UILabel!
    @IBOutlet weak var goodsWorthLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
