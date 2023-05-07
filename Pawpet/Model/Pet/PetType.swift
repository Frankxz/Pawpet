//
//  PetType.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import Foundation

enum PetType: String, CaseIterable {
    case cat
    case dog
    case fish
    case rodent
    case reptile
    case other
    case bird

    func getName() -> String {
        "\(self)".capitilizeFirstChar()
    }

    func getNamePlural() -> String {
        var type: String
        switch self {
        case .dog: type = "Dogs"
        case .cat: type = "Cats"
        case .fish: type = "Fishes"
        case .rodent: type = "Rodents"
        case .reptile: type = "Reptiles"
        case .bird: type = "Birds"
        case .other: type = "Other"
        }
        return type.localize()
    }
}
