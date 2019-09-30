//
//  Product.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/21/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation

var productID = String()
var productIDArray = [String]()

struct Product {
    var brand: String
    var description: String
    var price: NSNumber
    var productDescription: String
    var catalogCompilationID: String
    var id: String
    
    var dictionary: [String: Any] {
        return [
            "brand": brand,
            "description": description,
            "price": price,
            "productDescription": productDescription,
            "catalogCompilationID": catalogCompilationID
        ]
    }
    
}

extension Product {
    init?(dictionary: [String: Any], id: String) {
        guard
            let brand = dictionary["brand"] as? String,
            let description = dictionary["description"] as? String,
            let price = dictionary["price"] as? NSNumber,
            let catalogCompilationID = dictionary["catalogCompilationID"] as? String,
            let productDescription = dictionary["productDescription"] as? String
            else { return nil }
        self.init(brand: brand, description: description, price: price, productDescription: productDescription, catalogCompilationID: catalogCompilationID, id: id)
    }
}
