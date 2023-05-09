//
//  ColorImageView.swift
//  Pawpet
//
//  Created by Robert Miller on 08.05.2023.
//

import UIKit

class ColorImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.subtitleColor.cgColor
        self.layer.borderWidth = 0.4

        snp.makeConstraints { make in
            make.height.width.equalTo(22)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(colorType: PetColorType) {
        switch colorType {
        case .black: self.backgroundColor = .black
        case .white: self.backgroundColor = .white
        case .brown: self.backgroundColor = .systemBrown
        case .pale:  self.backgroundColor = hexColor(hex: "FFE7BC")
        case .gray:  self.backgroundColor = .systemGray
        case .ginger: self.backgroundColor = hexColor(hex: "E76334")
        case .spotted: self.image = UIImage(named: "spotted_color")
        case .tiger: self.image = UIImage(named: "tiger_color")
        case .gold: self.backgroundColor = hexColor(hex: "D4AF37")
        }
    }
}
