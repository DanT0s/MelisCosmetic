//
//  CatalogCollectionViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/25/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class CatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var catalogNameLabel: UILabel!
    @IBOutlet weak var catalogImage: UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
    }
}
