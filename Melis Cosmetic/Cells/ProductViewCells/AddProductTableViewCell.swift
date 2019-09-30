//
//  AddProductTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/17/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class AddProductTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var addToCartLabel: UIButton! 
    
    @IBAction func toFavoriteButton(_ sender: Any) {

    }
    
    @IBOutlet weak var imageLikeFavorite: UIImageView!

    @IBOutlet weak var imageShare: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    
    }


