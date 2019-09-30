//
//  CompilationTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/11/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit

class CompilationTableViewCell: UITableViewCell {

    @IBOutlet weak var compilationImageView: UIImageView!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
