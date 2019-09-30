//
//  User.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/27/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import Foundation


struct User {
    var email: String
    var name: String
    var surname: String
    var phoneNumber: String
    var adress: String
    var city: String
    var state: String
    var country: String
    
    
    var dictionary: [String:Any] {
        return [
            "name": name,
            "surname": surname,
            "email": email,
            "phoneNumber": phoneNumber,
            "adress": adress,
            "city": city,
            "state": state,
            "country": country
        ]
    }
    
}

extension User {
    init?(dictionary: [String:Any], id: String) {
        guard let name = dictionary["name"] as? String,
        let surname = dictionary["surname"] as? String,
        let email = dictionary["email"] as? String,
        let phoneNumber = dictionary["phoneNumber"] as? String,
        let adress = dictionary["adress"] as? String,
        let city = dictionary["city"] as? String,
        let state = dictionary["state"] as? String,
        let country = dictionary["country"] as? String
            else { return nil }
        self.init(email: email, name: name, surname: surname, phoneNumber: phoneNumber, adress: adress, city: city, state: state, country: country)
    }
}
