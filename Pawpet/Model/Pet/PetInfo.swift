//
//  PetInfo.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import Foundation

class PetInfo {
    var petType: PetType
    var isCrossbreed: Bool?
    var breed: String
    var secondBreed: String?
    
    var age: Int  // В месяцах
    var isMale: Bool
    var color: PetColorType
    
    var isCupping: Bool?
    var isSterilized: Bool?
    var isVaccinated: Bool?
    var isWithDocuments: Bool?
    
    var description: String = ""
    
    init(petType: PetType, isCrossbreed: Bool? = nil, breed: String, secondBreed: String? = nil, age: Int, isMale: Bool, color: PetColorType, isCupping: Bool? = nil, isSterilized: Bool? = nil, isVaccinated: Bool? = nil, isWithDocuments: Bool? = nil, description: String) {
        self.petType = petType
        self.isCrossbreed = isCrossbreed
        self.breed = breed
        self.secondBreed = secondBreed
        self.age = age
        self.isMale = isMale
        self.color = color
        self.isCupping = isCupping
        self.isSterilized = isSterilized
        self.isVaccinated = isVaccinated
        self.isWithDocuments = isWithDocuments
        self.description = description
    }

    init() {
        petType = .dog
        breed = ""
        age = 0
        isMale = false
        color = .black
    }
    
    func copy() -> PetInfo {
        return PetInfo(petType: petType, isCrossbreed: isCrossbreed, breed: breed, secondBreed: secondBreed, age: age, isMale: isMale, color: color, isCupping: isCupping, isSterilized: isSterilized, isVaccinated: isVaccinated, isWithDocuments: isWithDocuments, description: description)
    }
}

extension PetInfo {
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [
            "petType": petType.rawValue,
            "breed": breed,
            "age": age,
            "isMale": isMale,
            "color": color.rawValue,
            "description": description
        ]
        
        if let isCrossbreed = isCrossbreed {
            dictionary["isCrossbreed"] = isCrossbreed
        }
        if let secondBreed = secondBreed {
            dictionary["secondBreed"] = secondBreed
        }
        if let isCupping = isCupping {
            dictionary["isCupping"] = isCupping
        }
        if let isSterilized = isSterilized {
            dictionary["isSterilized"] = isSterilized
        }
        if let isVaccinated = isVaccinated {
            dictionary["isVaccinated"] = isVaccinated
        }
        if let isWithDocuments = isWithDocuments {
            dictionary["isWithDocuments"] = isWithDocuments
        }
        
        return dictionary
    }
}

extension PetInfo {
    static func fromDictionary(dictionary: [String: Any]) -> PetInfo? {
        guard let petTypeString = dictionary["petType"] as? String,
              let colorTypeString = dictionary["color"] as? String,
              let petType = PetType(rawValue: petTypeString),
              let breed = dictionary["breed"] as? String,
              let age = dictionary["age"] as? Int,
              let isMale = dictionary["isMale"] as? Bool,
              let color = PetColorType(rawValue: colorTypeString),
              let description = dictionary["description"] as? String else { return nil }

        let isCrossbreed = dictionary["isCrossbreed"] as? Bool
        let secondBreed = dictionary["secondBreed"] as? String
        let isCupping = dictionary["isCupping"] as? Bool
        let isSterilized = dictionary["isSterilized"] as? Bool
        let isVaccinated = dictionary["isVaccinated"] as? Bool
        let isWithDocuments = dictionary["isWithDocuments"] as? Bool

        return PetInfo(petType: petType, isCrossbreed: isCrossbreed, breed: breed, secondBreed: secondBreed, age: age, isMale: isMale, color: color, isCupping: isCupping, isSterilized: isSterilized, isVaccinated: isVaccinated, isWithDocuments: isWithDocuments, description: description)
    }
}
