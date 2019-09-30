//
//  Utilities.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/10/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield: UITextField) {
        
        //Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        //Remve border on text field
        textfield.borderStyle = .none
        
        //Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button: UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    
}

protocol CustomCellDelegate {
    func showAlert(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
