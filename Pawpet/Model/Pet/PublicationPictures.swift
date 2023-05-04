//
//  PetPictures.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import UIKit
import SDWebImage

class PublicationPictures {
    var mainImage: PawpetImage
    var images: [PawpetImage]?
    
    var allImages: [PawpetImage] {
        var all = [mainImage]
        if let additionalImages = images {
            all.append(contentsOf: additionalImages)
        }
        return all
    }
    
    init(mainImage: PawpetImage, images: [PawpetImage]? = nil) {
        self.mainImage = mainImage
        self.images = images
    }

    init() {
        mainImage = PawpetImage()
    }

    func copy() -> PublicationPictures {
        return PublicationPictures(mainImage: mainImage, images: images)
    }

    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [
            "mainImage": mainImage.url?.absoluteString ?? ""
        ]
        
        if let images = images {
            dictionary["images"] = images.compactMap { $0.url?.absoluteString }
        }
        
        return dictionary
    }
}

extension PublicationPictures {
    func setUIImages(images input: [UIImage]) {
        if !input.isEmpty {
            if images == nil {
                images = []
            }
            for item in input {
                self.images?.append(PawpetImage(image: item))
            }
        }
    }
}

extension PublicationPictures {
    static func fromDictionary(dictionary: [String: Any]) -> PublicationPictures? {
        guard let mainImageURLString = dictionary["mainImage"] as? String,
              let mainImageURL = URL(string: mainImageURLString) else { return nil }

        let mainImage = PawpetImage(image: UIImage(), url: mainImageURL)
        var images: [PawpetImage]? = nil

        if let imageURLStrings = dictionary["images"] as? [String] {
            images = []
            for urlString in imageURLStrings {
                if let imageURL = URL(string: urlString) {
                    let image = PawpetImage(image: UIImage(), url: imageURL)
                    images?.append(image)
                }
            }
        }

        return PublicationPictures(mainImage: mainImage, images: images)
    }
}

extension PublicationPictures {
    func loadImages(into imageViews: [UIImageView]) {
        guard let images = images else { return }

        for (index, pawpetImage) in images.enumerated() {
            if index < imageViews.count {
                pawpetImage.loadMainImage(into: imageViews[index])
            }
        }
    }
}
