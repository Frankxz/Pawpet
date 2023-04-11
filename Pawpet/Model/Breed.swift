//
//  Breed.swift
//  Pawpet
//
//  Created by Robert Miller on 11.04.2023.
//

import Foundation

class Breed {
    var name: String
    var isChecked: Bool

    init(name: String, isChecked: Bool = false) {
        self.name = name
        self.isChecked = isChecked
    }

    static func generateBreeds() -> [Breed] {
        let breedsString = ["Labrador Retriever", "German Shepherd", "Golden Retriever", "Bulldog", "Beagle",  "French Bulldog", "Poodle", "Rottweiler", "Yorkshire Terrier", "Boxer","Siberian Husky", "Dachshund", "Doberman Pinscher", "Shih Tzu", "Great Dane", "Miniature Schnauzer", "Australian Shepherd", "Cavalier King Charles Spaniel", "Pomeranian", "Boston Terrier", "Bernese Mountain Dog", "Shetland Sheepdog", "Pembroke Welsh Corgi", "Havanese", "Akita","Border Collie", "Bichon Frise", "Weimaraner", "Basset Hound", "Vizsla","Shar Pei", "West Highland White Terrier", "Collie", "Bloodhound", "Chihuahua", "English Springer Spaniel", "Saint Bernard", "Newfoundland", "Pug", "Alaskan Malamute","Chow Chow", "Irish Setter", "Cocker Spaniel", "Rhodesian Ridgeback", "Dalmatian","Old English Sheepdog", "Chinese Shar-Pei", "Greyhound", "Whippet", "Basenji"]
        var breeds: [Breed] = []

        for breed in breedsString {
            breeds.append(Breed(name: breed))
        }
        return breeds
    }
}
