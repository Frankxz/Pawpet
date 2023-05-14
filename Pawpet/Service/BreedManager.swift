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
    var allBreeds: [String] = []

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


    func getAllBreeds(completion: @escaping ([String])->()) {
        if !BreedManager.shared.allBreeds.isEmpty {
            print("Allbreeds already fetched")
            completion(allBreeds)
            return
        } 

        let filteredPetTypes: [PetType] = PetType.allCases.filter { $0 != .all }
        var breeds: [String] = []
        let dispatchGroup = DispatchGroup()

        for type in filteredPetTypes {
            dispatchGroup.enter()
            loadData(for: type) { fetchedBreeds in
                breeds.append(contentsOf: fetchedBreeds)
                print("breeds for \(type) fetched and added")
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("all breeds are fetched")
            BreedManager.shared.allBreeds = breeds
            completion(breeds)
        }
    }
}
