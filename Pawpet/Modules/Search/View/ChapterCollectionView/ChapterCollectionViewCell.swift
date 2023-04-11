//
//  ChapterCollectionViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {

    static let reuseId = "ChapterCell"

    // MARK: - UI components
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .backgroundColor
        imageView.layer.cornerRadius = 6
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .subtitleColor
        label.textAlignment = .center
        label.text = "Test"
        return label
    }()

    // MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImageView)
        addSubview(nameLabel)

        mainImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
