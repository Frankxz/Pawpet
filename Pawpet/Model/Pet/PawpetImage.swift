//
//  PawpetImage.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import UIKit
import SDWebImage

class PawpetImage {
    let image: UIImage
    var url: URL?

    init () {
        image = UIImage()
    }

    init(image: UIImage, url: URL? = nil) {
        self.image = image
        self.url = url
    }
}

extension PawpetImage {
    func loadMainImage(into imageView: UIImageView) {
        guard let url = url else { return }
        imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder")
        )
    }
}

