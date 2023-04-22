//
//  CityTableViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit
import SnapKit

class CityTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CityTableViewCell"

    let checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.addSubview(checkboxImageView)
        checkboxImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
        selectionStyle = .none
    }

    func configure(city: City) {
        textLabel?.text = city.name
        UIView.animate(withDuration: 0.3) {
            self.checkboxImageView.image = city.isChecked ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
            self.checkboxImageView.tintColor = city.isChecked ? .systemGreen : .subtitleColor
        }
    }
}

