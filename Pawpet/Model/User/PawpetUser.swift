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
    var phoneNumber: String?
    var city: String?
    var image: UIImage?
    var currency: String?
    var favorites: [String]? // Содержит id публикаций

    var isChanged: Bool = true

    init(name: String? = nil, surname: String? = nil, country: String? = nil, phoneNumber: String? = nil, city: String? = nil, image: UIImage? = nil, currency: String? = nil, favorites: [String]? = nil) {
        self.name = name
        self.surname = surname
        self.country = country
        self.phoneNumber = phoneNumber
        self.city = city
        self.image = image
        self.currency = currency
        self.favorites = favorites
    }
}
