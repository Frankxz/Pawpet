//
//  PetType.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import Foundation

enum PetType: String, CaseIterable {
    case all
    case dog
    case cat
    case fish
    case rodent
    case bird
}

extension PetType {
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
        case .bird: type = "Birds"
        case .all: type = "All"
        }
        return type.localize()
    }
}


