//
//  ProductCart.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/20/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation


struct ProductCart {
    var description: String
    var price: NSNumber
    var imageName: String
    var quantity: NSNumber
    var id: String
    
    var dictionary: [String:Any] {
        return [
            "description":description,
            "price":price,
            "imageName": imageName,
            "quantity": quantity
        ]
    }
    
}

extension ProductCart {
    init?(dictionary: [String:Any], id: String) {
        guard
            let description = dictionary["description"] as? String,
            let price = dictionary["price"] as? NSNumber,
            let imageName = dictionary["imageName"] as? String,
            let quantity = dictionary["quantity"] as? NSNumber
            else { return nil }
        self.init(description: description, price: price, imageName: imageName, quantity: quantity,id: id)
    }
}
