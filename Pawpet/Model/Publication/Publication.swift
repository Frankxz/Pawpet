//
//  Publication.swift
//  Pawpet
//
//  Created by Robert Miller on 01.05.2023.
//

import UIKit

class Publication {
    var id: String
    var authorID: String
    
    var petInfo: PetInfo
    var pictures: PublicationPictures
    var price: Int
    var currency: String
    var country: String
    var city: String

    init(id: String, authorID: String, petInfo: PetInfo, pictures: PublicationPictures, price: Int, currency: String, country: String, city: String) {
        self.id = id
        self.authorID = authorID
        self.petInfo = petInfo
        self.pictures = pictures
        self.price = price
        self.currency = currency
        self.country = country
        self.city = city
    }

    init() {
        id = ""
        authorID = ""
        petInfo = PetInfo()
        pictures = PublicationPictures()
        price = 0
        currency = ""
        country = ""
        city = ""
    }
    
    func copy(withUpdatedImages updatedImages: [PawpetImage]) -> Publication {
        var updatedPictures: PublicationPictures
        if updatedImages.isEmpty {
            updatedPictures = PublicationPictures()
        } else {
            updatedPictures = PublicationPictures(mainImage: updatedImages[0], images: Array(updatedImages.dropFirst()))
        }
           return Publication(id: id, authorID: authorID, petInfo: petInfo.copy(), pictures: updatedPictures, price: price, currency: currency, country: country, city: city)
       }
}

extension Publication {
    static func fromDictionary(id: String, dictionary: [String: Any]) -> Publication? {
        guard let authorID = dictionary["authorID"] as? String,
              let petInfoData = dictionary["petInfo"] as? [String: Any],
              let petInfo = PetInfo.fromDictionary(dictionary: petInfoData),
              let picturesData = dictionary["pictures"] as? [String: Any],
              let pictures = PublicationPictures.fromDictionary(dictionary: picturesData),
              let price = dictionary["price"] as? Int,
              let currency = dictionary["currency"] as? String,
              let country = dictionary["country"] as? String,
              let city = dictionary["city"] as? String else { return nil }

        return Publication(id: id, authorID: authorID, petInfo: petInfo, pictures: pictures, price: price, currency: currency, country: country, city: city)
    }
}

extension Publication {
    func copy(withChangedData changedData: [String: Any]) -> Publication {
        let updatedPublication = Publication()
        updatedPublication.id = self.id
        updatedPublication.authorID = self.authorID
        updatedPublication.pictures = self.pictures

        if let petInfoData = changedData["petInfo"] as? [String: Any] {
            updatedPublication.petInfo = PetInfo.fromDictionary(dictionary: petInfoData) ?? self.petInfo
        } else {
            updatedPublication.petInfo = self.petInfo
        }

        if let price = changedData["price"] as? Int {
            updatedPublication.price = price
        } else {
            updatedPublication.price = self.price
        }

        if let currency = changedData["currency"] as? String {
            updatedPublication.currency = currency
        } else {
            updatedPublication.currency = self.currency
        }

        return updatedPublication
    }
}

