//
//  Task.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/27/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation


var catalogID = String()

struct Catalog {
    var catalogName: String
    var id: String
    
    var dictionary: [String:Any] {
        return [
            "catalogName":catalogName
        ]
    }
    
}

extension Catalog {
    init?(dictionary: [String:Any], id: String) {
        guard let catalogName = dictionary["catalogName"] as? String
            else { return nil }
        self.init(catalogName: catalogName, id: id)
    }
}
