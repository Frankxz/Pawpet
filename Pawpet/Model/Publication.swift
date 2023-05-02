//
//  Publication.swift
//  Pawpet
//
//  Created by Robert Miller on 01.05.2023.
//

import UIKit

class Publication {
    var id: String = ""
    var petType: PetType = .dog
    var isCrossbreed: Bool?
    var breed: String = ""
    var secondBreed: String?

    var age: Int  = 0 // В месяцах
    var isMale: Bool = false
    var description: String = ""

    var price: Int = 0
    var currency: String = "RUB"
    
    var isCupping: Bool?
    var isSterilized: Bool?
    var isVaccinated: Bool?

    var pictures: [UIImage] = []
    var location: [String: String] = [:]

    var userID: String = ""

    init(id: String, petType: PetType, isCrossbreed: Bool?, breed: String, secondBreed: String?, age: Int, isMale: Bool, description: String, price: Int, currency: String, isCupping: Bool?, isSterilized: Bool?, isVaccinated: Bool?, pictures: [UIImage], location: [String : String], userID: String) {
        self.id = id
        self.petType = petType
        self.isCrossbreed = isCrossbreed
        self.breed = breed
        self.secondBreed = secondBreed
        self.age = age
        self.isMale = isMale
        self.description = description
        self.price = price
        self.currency = currency
        self.isCupping = isCupping
        self.isSterilized = isSterilized
        self.isVaccinated = isVaccinated
        self.pictures = pictures
        self.location = location
        self.userID = userID
    }

    init() {
        
    }
}

enum PetType: String, CaseIterable {
    case cat
    case dog
    case fish
    case rodent
    case reptile
    case other
    case bird

    func getName() -> String {
        "\(self)"
    }
}
