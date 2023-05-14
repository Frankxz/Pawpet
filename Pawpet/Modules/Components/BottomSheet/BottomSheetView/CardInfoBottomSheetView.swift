//
//  CardInfoBottomSheetView.swift
//  Pawpet
//
//  Created by Robert Miller on 30.03.2023.
//

import UIKit
import Firebase

class CardInfoBottomSheetView: BottomSheetView{
    // MARK: - Properties
    private let titleView = PromptView(with: "Husky", and: "Dog")
    private let priceLabel = LabelView(text: "", size: 22, viewColor: .clear, textColor: .systemRed, edgeOffset: 4)

    private var infoCollectionView = InfoCollectionView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .justified
        return label
    }()

    private var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.subtitleColor.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()

    private let authorLabel = PromptView(with: "Maybe Baby", and: "Owner", titleSize: 22, subtitleSize: 14)

    private let authorGeoLabel: UILabel = {
        let label = UILabel()
        label.text = "850 m."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .subtitleColor
        label.textAlignment = .right
        return label
    }()

    // MARK: - Init
    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension CardInfoBottomSheetView {
    private func setupInfoView(with infoCollectionViewHeight: CGFloat, and price: Int) {
        let authorStackView = getAuthorStackView()

        containerView.addSubview(titleView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(infoCollectionView)
        containerView.addSubview(authorStackView)
        containerView.addSubview(authorGeoLabel)
        containerView.addSubview(descriptionLabel)

        titleView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
            make.right.equalTo(priceLabel.snp.left).inset(-20)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.top).inset(price > 0 ? 0 : 4)
            make.right.equalToSuperview().inset(20)
        }

        infoCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleView.snp.bottom).offset(10)
            make.height.equalTo(infoCollectionViewHeight)
        }

        authorStackView.snp.makeConstraints { make in
            make.top.equalTo(infoCollectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
        }

        authorGeoLabel.snp.makeConstraints { make in
            make.top.equalTo(authorStackView.snp.top)
            make.right.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    private func getAuthorStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20

        authorImageView.snp.makeConstraints{$0.width.height.equalTo(40)}

        stackView.addArrangedSubview(authorImageView)
        stackView.addArrangedSubview(authorLabel)
        return stackView
    }
}

// MARK: - Configuring CardInfo
extension CardInfoBottomSheetView {
    public func configure(with publication: Publication) {
        setupBreed(with: publication)
        setupPrice(with: publication)
        setupAuthorInfo(with: publication)
        setupPetInfo(with: publication)
    }

    // MARK: Breed & Description
    private func setupBreed(with publication: Publication) {
        titleView.setupTitles(title: publication.petInfo.breed, subtitle: publication.petInfo.petType.getName())
        descriptionLabel.text = publication.petInfo.description
    }

    // MARK: Price
    private func setupPrice(with publication: Publication) {
        if publication.price > 0 {
            priceLabel.setupTitle(with: "   \(publication.price.formatPrice()) \(publication.currency.inCurrencySymbol())   ")
            priceLabel.setupColors(viewColor: .systemYellow, textColor: .accentColor.withAlphaComponent(0.8))
        } else {
            priceLabel.setupTitle(with: "  \("FREE".localize())  ")
            priceLabel.setupColors(viewColor: .systemGreen, textColor: .white)
        }
    }

    // MARK: Author Info
    private func setupAuthorInfo(with publication: Publication) {
        UserManager.shared.fetchUserData(for: publication.authorID) { author in
            self.authorLabel.setupTitles(title: "\(author.name ?? "") \(author.surname ?? "")", subtitle: "Owner".localize())
            self.authorGeoLabel.text = "\(author.country ?? "")\n\(author.city ?? "")"
        }

        if publication.authorID == Auth.auth().currentUser?.uid {
            UserManager.shared.fetchAvatarImage(imageView: authorImageView) {}
        } else {
            UserManager.shared.fetchAvatarImage(id: publication.authorID, imageView: authorImageView) {}
        }
    }

    // MARK: Pet Info
    private func setupPetInfo(with publication: Publication) {
        let info = publication.petInfo
        let stringYES = "Yes".localize()
        let stringNO = "No".localize()

        let gender = info.isMale ? "Male".localize() : "Female".localize()
        let age = "\(publication.petInfo.age) \("m.".localize())"
        let color = info.color.rawValue.localize()

        infoCollectionView.labelViews.append(LabelView(prompt: "Gender", value: gender))
        infoCollectionView.labelViews.append(LabelView(prompt: "Age", value: age))
        infoCollectionView.labelViews.append(LabelView(prompt: "Color", value: color))

        if info.isSterilized != nil {
            let sterilized = info.isSterilized! ? stringYES : stringNO
            infoCollectionView.labelViews.append(LabelView(prompt: "Sterilized", value: sterilized))
        }
        
        if  info.isCupping != nil {
            let cupping = info.isCupping! ? stringYES : stringNO
            infoCollectionView.labelViews.append(LabelView(prompt: "Cupping", value: cupping))
        }

        if info.isVaccinated != nil {
            let vaccinated = info.isVaccinated! ? stringYES : stringNO
            infoCollectionView.labelViews.append(LabelView(prompt: "Vaccinated", value: vaccinated, isGreenText: info.isVaccinated!))
        }

        if info.isWithDocuments != nil {
            let isWithDocuments = info.isWithDocuments! ? stringYES : stringNO
            infoCollectionView.labelViews.append(LabelView(prompt: "Documents", value: isWithDocuments, isGreenText: info.isWithDocuments!))
        }

        let height: CGFloat = infoCollectionView.labelViews.count > 5 ? 120 : 60
        infoCollectionView.reloadData()
        setupInfoView(with: height, and: publication.price)
    }
}
