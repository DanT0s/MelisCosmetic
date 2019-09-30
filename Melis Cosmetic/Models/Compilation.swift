//
//  Compilation.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/3/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation

struct Compilation {
    var description: String
    var secondDescription: String
    var catalogCompilationID: String
    var id: String
    
    var dictionary: [String:Any] {
        return [
            "description":description,
            "secondDescription":secondDescription,
            "catalogCompilationID": catalogCompilationID
        ]
    }
    
}

extension Compilation {
    init?(dictionary: [String:Any], id: String) {
        guard
            let description = dictionary["description"] as? String,
            let secondDescription = dictionary["secondDescription"] as? String,
            let catalogCompilationID = dictionary["catalogCompilationID"] as? String
            else { return nil }
        self.init(description: description, secondDescription: secondDescription, catalogCompilationID: catalogCompilationID, id: id)
    }
}
