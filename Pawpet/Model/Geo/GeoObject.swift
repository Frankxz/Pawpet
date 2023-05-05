//
//  GeoObject.swift
//  Pawpet
//
//  Created by Robert Miller on 28.04.2023.
//

import Foundation

class GeoObject: Codable {
    let name: String
    var isChecked: Bool

    init(name: String, isChecked: Bool) {
        self.name = name
        self.isChecked = isChecked
    }
}
