//
//  Favorites.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/4/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation

var favoritesIDArray = [String]()

struct Favorites {
    var description: String
    var price: NSNumber
    var imageName: String
    var catalogCompilationID: String
    var id: String
    
    var dictionary: [String:Any] {
        return [
            "description":description,
            "price":price,
            "catalogCompilationID": catalogCompilationID,
            "imageName": imageName
        ]
    }
    
}

extension Favorites {
    init?(dictionary: [String:Any], id: String) {
        guard
            let description = dictionary["description"] as? String,
            let price = dictionary["price"] as? NSNumber,
            let catalogCompilationID = dictionary["catalogCompilationID"] as? String,
            let imageName = dictionary["imageName"] as? String
            else { return nil }
        self.init(description: description, price: price, imageName: imageName, catalogCompilationID: catalogCompilationID, id: id)
    }
}
