//
//  FirestoreReferenceManager.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/14/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Firebase

struct FirestoreReferenceManager {
    
    
    static let db = Firestore.firestore()
    
    static func referenceForUserPublicData(uid: String) -> DocumentReference {
        return db
            .collection(FirebaseKeys.CollectionPath.users)
            .document(uid)
            .collection(FirebaseKeys.CollectionPath.publicData)
            .document(FirebaseKeys.CollectionPath.publicData)
    }
    
    
}
