//
//  PawpetUser.swift
//  Pawpet
//
//  Created by Robert Miller on 27.04.2023.
//

import UIKit

class PawpetUser {
    var name: String?
    var surname: String?
    var country: String?
    var city: String?
    var image: UIImage?
    var currency: String?

    init(name: String? = nil, surname: String? = nil, country: String? = nil, city: String? = nil, image: UIImage? = nil, currency: String? = nil) {
        self.name = name
        self.surname = surname
        self.country = country
        self.city = city
        self.image = image
        self.currency = currency
    }
}
