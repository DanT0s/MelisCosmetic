//
//  Task.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/27/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation
import Firebase

struct Catalog {
    let antiAging: String
    let crema: String
    let faceCleaning: String
    let foundationСreams: String
    let masks: String
    
    let ref: DatabaseReference
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        catalog = snapshotValue["catalog"] as! String
        ref = snapshot.ref
    }
}
