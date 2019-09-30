//
//  MyOrders.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/9/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation

struct MyOrders {
    var date: String
    var fullPrice: String
    var products: [String]
    var id: String
    
    var dictionary: [String: Any] {
        return [
            "date": date,
            "fullPrice": fullPrice,
            "products": products
        ]
    }
    
}

extension MyOrders {
    init?(dictionary: [String: Any], id: String) {
        guard
            let date = dictionary["date"] as? String,
            let fullPrice = dictionary["fullPrice"] as? String,
            let products = dictionary["products"] as? [String]
            else { return nil }
        self.init(date: date, fullPrice: fullPrice, products: products, id: id)
    }
}
