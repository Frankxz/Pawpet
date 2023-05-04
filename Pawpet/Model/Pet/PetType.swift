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
        "\(self)"
    }
}
