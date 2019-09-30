//
//  ProductTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/17/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class ImageProductTableViewCell: UITableViewCell {
  
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addedLabelImage: UIImageView!
    @IBOutlet weak var addedLabelText: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
