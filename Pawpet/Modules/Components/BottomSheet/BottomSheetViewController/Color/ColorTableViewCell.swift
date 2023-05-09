//
//  ColorTableViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 07.05.2023.
//

import UIKit
import SnapKit

class ColorTableViewCell: UITableViewCell {

    var colorType: PetColorType = .black
    let colorLabel = UILabel()
    let colorCircle = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(colorLabel)
        contentView.addSubview(colorCircle)

        colorLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }

        colorCircle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
        }

        colorCircle.layer.cornerRadius = 10
        colorCircle.clipsToBounds = true
        colorCircle.layer.borderColor = UIColor.subtitleColor.cgColor
        colorCircle.layer.borderWidth = 0.4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(colorType: PetColorType) {
        self.colorType = colorType
        colorLabel.text = colorType.rawValue.localize()
        switch colorType {
        case .black: colorCircle.backgroundColor = .black
        case .white: colorCircle.backgroundColor = .white
        case .brown: colorCircle.backgroundColor = .systemBrown
        case .pale:  colorCircle.backgroundColor = hexColor(hex: "FFE7BC")
        case .gray:  colorCircle.backgroundColor = .systemGray
        case .ginger: colorCircle.backgroundColor = hexColor(hex: "E76334")
        case .spotted: colorCircle.image = UIImage(named: "spotted_color")
        case .tiger: colorCircle.image = UIImage(named: "tiger_color")
        case .gold: colorCircle.backgroundColor = hexColor(hex: "D4AF37")
        }
    }
}

