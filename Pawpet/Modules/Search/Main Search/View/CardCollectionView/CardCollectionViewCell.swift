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
        imageView.backgroundColor = .backgroundColor
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

    let priceLabel = LabelView(text: "", weight: .heavy, viewColor: .clear, textColor: .systemRed, edgeOffset: 4)

    // MARK: - Buttons
    lazy var saveButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .subtitleColor
        return button
    }()

    var publication: Publication?
    var isInFavorite: Bool = false

    var deleteCellFromFavorites: (() -> Void)?

    // MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension CardCollectionViewCell {
    private func configurateView(withHeart: Bool) {
        backgroundColor = .backgroundColor
        layer.cornerRadius = 6
        
        setupConstraints(withHeart: withHeart)
    }

    private func setupConstraints(withHeart: Bool) {
        addSubview(mainImageView)
        addSubview(infoLabel)
        addSubview(priceLabel)

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

        priceLabel.snp.removeConstraints()
        priceLabel.snp.makeConstraints() { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.equalTo(mainImageView.snp.right).offset(20)
        }

        if withHeart {
            addSubview(saveButton)
            saveButton.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(10)
                make.bottom.equalToSuperview()
                make.height.equalTo(36)
                make.width.equalTo(36)
            }
        }
    }

    func configure(with publication: Publication, withHeart: Bool = true) {
        configurateView(withHeart: withHeart)
       
        if let favorites = FireStoreManager.shared.user.favorites, favorites.contains(publication.id) {
            if !isInFavorite  {
                print("\nIN Favorites \(isInFavorite)")
                updateSaveButtonAppearence { _ in }
                print("IN Favorites \(isInFavorite)")
            }
        } else {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
            let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
            saveButton.setImage(image, for: .normal)
            saveButton.tintColor = .subtitleColor
            isInFavorite = false
        }

        self.publication = publication
        infoLabel.subtitleLabel.numberOfLines = 2
        infoLabel.setupTitles(title: publication.petInfo.breed,
                              subtitle: publication.petInfo.description)
        publication.pictures.mainImage.loadMainImage(into: mainImageView)

        if publication.price > 0 {
            priceLabel.setupTitle(with: "  \(publication.price.formatPrice()) \(publication.currency.inCurrencySymbol())  ")
            priceLabel.setupColors(viewColor: .subtitleColor.withAlphaComponent(0.3), textColor: .accentColor.withAlphaComponent(0.8))
        } else {
            priceLabel.setupTitle(with: "  FREE  ")
            priceLabel.setupColors(viewColor: .systemGreen, textColor: .white)
        }
    }
}

// MARK: - SaveButton
extension CardCollectionViewCell {
    @objc private func saveButtonTapped() {
        updateSaveButtonAppearence() { isInFavoriteNow in
            guard let publicationID = self.publication?.id else { return }
            if isInFavoriteNow {
                PublicationManager.shared.addToFavorites(publicationID: publicationID) { result in
                    switch result {
                    case .success:
                        print("Succesufuly saved to favorites")
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            } else {
                PublicationManager.shared.removeFromFavorites(publicationID: publicationID) { result in
                    switch result {
                    case .success:
                        print("Succesufuly deleted from favorites")
                        (self.deleteCellFromFavorites ?? {})()
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            }
        }
    }

    func updateSaveButtonAppearence(completion: @escaping (Bool)->()) {
        let color: UIColor = isInFavorite ? .subtitleColor : .systemRed
        let imageName = isInFavorite ? "heart" : "heart.fill"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)

        UIView.animate(withDuration: 0.2) {
            self.saveButton.setImage(image, for: .normal)
            self.saveButton.tintColor = color
        }

        isInFavorite.toggle()
        completion(isInFavorite)
    }
}
