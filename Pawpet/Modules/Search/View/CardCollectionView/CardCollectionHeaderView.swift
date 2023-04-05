//
//  CardCollectionHeaderView.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

class CardCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CardHeaderView"

    // MARK: - Labels
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "Hello, ", boldString: "Miller ✋🏼", font: .systemFont(ofSize: 32))
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    // MARK: - Segmented control
    private let sectionControl: CustomSegmentedControl = {
        let items = ["Animals", "Accessories", "Feed"]
        let control = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: 320, height: 40), items: items)
        return control
    }()

    // MARK: - ImageView
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.subtitleColor.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .random()
        return imageView
    }()

    // MARK: - CollectionView
    private let chapterCollectionView = ChapterCollectionView()
}

// MARK: - UI + Constraints
extension CardCollectionHeaderView {
    public func configure() {
        addSubview(avatarImageView)
        addSubview(sectionControl)
        addSubview(welcomeLabel)
        addSubview(chapterCollectionView)

        chapterCollectionView.clipsToBounds = false

        welcomeLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }

        sectionControl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }

        chapterCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sectionControl.snp.bottom).offset(20)
            make.height.equalTo(140)
        }

        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(welcomeLabel.snp.top)
            make.right.equalToSuperview()
        }
    }
}
