//
//  AddProductTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/17/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class AddProductTableViewCell: UITableViewCell  {

    @IBAction func productAddToCartButton(_ sender: Any) {
    
    }
    
    @IBOutlet weak var addToCartLabel: UIButton! 
    
    @IBAction func toFavoriteButton(_ sender: Any) {
    }
    @IBOutlet weak var imageLikeFavorite: UIImageView!
    
    @IBAction func shareButton(_ sender: Any) {
        
    }

    @IBOutlet weak var imageShare: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    }


