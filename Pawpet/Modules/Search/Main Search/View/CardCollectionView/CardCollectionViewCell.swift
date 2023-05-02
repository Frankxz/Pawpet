//
//  CardCollectionViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    static let reuseId = "CardCell"

    // MARK: - ImageView
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .random()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.subtitleColor.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Labels
    let infoLabel = PromptView(
        with: "White Husky",
        and: "Very pretty puppy with aqua blue eyes and kind soul.",
        titleSize: 18,
        subtitleSize: 14,
        spacing: 8)

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .left
        label.text = "120$"
        return label
    }()

    // MARK: - Buttons
    let saveButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)

        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .subtitleColor
        return button
    }()

    var publication: Publication?

    // MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension CardCollectionViewCell {
    private func configurateView() {
        backgroundColor = .backgroundColor
        layer.cornerRadius = 6
        
        setupConstraints()
    }

    private func setupConstraints() {
        addSubview(mainImageView)
        addSubview(infoLabel)
        addSubview(priceLabel)
        addSubview(saveButton)

        mainImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }

        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(mainImageView.snp.right).offset(20)
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }

        priceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.equalTo(mainImageView.snp.right).offset(20)
        }

        saveButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalTo(36)
        }
    }

    func configure(with publication: Publication) {
        self.publication = publication
        infoLabel.subtitleLabel.numberOfLines = 2
        infoLabel.setupTitles(title: publication.breed,
                              subtitle: publication.description)
        priceLabel.text = "\(publication.price) $"
        mainImageView.image = publication.pictures.first ?? UIImage(named: "pawpet")
    }
}

