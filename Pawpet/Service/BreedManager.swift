//
//  BreedManager.swift
//  Pawpet
//
//  Created by Robert Miller on 07.05.2023.
//

import Foundation
import Firebase

class BreedManager {
    static let shared = BreedManager()

    private let database = Database.database().reference(withPath: "breeds")

    private init() {}

    func loadData(for type: PetType, completion: @escaping ([String])->()) {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        let breedKey = preferredLanguage.hasPrefix("ru") ? "breeds_ru" : "breeds_en"
        let typePath = database.child("\(type)")
        typePath.child(breedKey).observeSingleEvent(of: .value) { snapshot in
            print("Succes fetched breeds")
            if let breedData = snapshot.value as? [String] {
                completion(breedData)
            }
        }
    }
}
