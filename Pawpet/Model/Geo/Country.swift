//
//  Country.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import Foundation

class Country: GeoObject {
    var cities: [GeoObject] = []

    init(name: String, cities: [String], isChecked: Bool = false) {
        for city in cities {
            self.cities.append(GeoObject(name: city, isChecked: false))
        }
        super.init(name: name, isChecked: isChecked)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
