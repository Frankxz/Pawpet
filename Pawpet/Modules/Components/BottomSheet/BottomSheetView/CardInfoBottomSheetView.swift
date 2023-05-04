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

    private let infoLabels = [
        LabelView(text: "Male", subtitle: "Gender", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
        LabelView(text: "2 y.", subtitle: "Age", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
        LabelView(text: "Yes", subtitle: "Sterilize", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
        LabelView(text: "Yes", subtitle: "Cupping", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor)
    ]

    private let additionInfoLabels = [
        LabelView(text: "Yes", subtitle: "Documents", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
        LabelView(text: "Yes", subtitle: "Vacine", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor)
    ]

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
        setupInfoView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UI + Constraints
extension CardInfoBottomSheetView {
    public func configure(with publication: Publication) {
        titleView.setupTitles(title: publication.petInfo.breed, subtitle: publication.petInfo.petType.getName())
        descriptionLabel.text = publication.petInfo.description

        if publication.price > 0 {
            priceLabel.setupTitle(with: "   \(publication.price.formatPrice()) \(publication.currency.inCurrencySymbol())   ")
            priceLabel.setupColors(viewColor: .systemYellow, textColor: .accentColor.withAlphaComponent(0.8))
        } else {
            priceLabel.setupTitle(with: "  FREE  ")
            priceLabel.snp.removeConstraints()
            priceLabel.snp.makeConstraints { make in
                make.top.equalTo(titleView.snp.top)
                make.right.equalToSuperview().inset(20)
            }
            priceLabel.setupColors(viewColor: .systemGreen, textColor: .white)
        }

        FireStoreManager.shared.fetchUserData(for: publication.authorID) { author in
            self.authorLabel.setupTitles(title: "\(author.name ?? "") \(author.surname ?? "")", subtitle: "Author")
            self.authorGeoLabel.text = "\(author.country ?? "")\n\(author.city ?? "")"
        }

        if publication.authorID == Auth.auth().currentUser?.uid {
            FireStoreManager.shared.fetchAvatarImage(imageView: authorImageView) {}
        } else {
            FireStoreManager.shared.fetchAvatarImage(id: publication.authorID, imageView: authorImageView) {}
        }

        let sex = publication.petInfo.isMale ? "Male" : "Female"
        let coupping = publication.petInfo.isCupping! ? "Yes" : "No" // REMOVE FORCE UNWRAP
        let vaccinated = publication.petInfo.isVaccinated! ? "Yes" : "No"
        let sterilized = publication.petInfo.isSterilized! ? "Yes" : "No"
        let isWithDocuments = publication.petInfo.isWithDocuments! ? "Yes" : "No"

        vaccinated == "Yes" ? (additionInfoLabels[1].mainLabel.textColor = .systemGreen) : (infoLabels[3].mainLabel.textColor = .accentColor)
        isWithDocuments == "Yes" ? (additionInfoLabels[0].mainLabel.textColor = .systemGreen) : (infoLabels[2].mainLabel.textColor = .accentColor)

        infoLabels[0].setupTitle(with: sex, and: "Gender")
        infoLabels[1].setupTitle(with: "\(publication.petInfo.age) m.", and: "Age")
        infoLabels[2].setupTitle(with: coupping, and: "Couping")
        infoLabels[3].setupTitle(with: sterilized, and: "Sterilized")

        additionInfoLabels[0].setupTitle(with: isWithDocuments, and: "Documents")
        additionInfoLabels[1].setupTitle(with: vaccinated)
    }

    private func setupInfoView() {
        let infoLabelsStackView = getInfoLabelStackView()
        let additionInfoLabelsStackView = getAditionInfoLabelStackView()
        let authorStackView = getAuthorStackView()

        containerView.addSubview(titleView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(infoLabelsStackView)
        containerView.addSubview(additionInfoLabelsStackView)
        containerView.addSubview(authorStackView)
        containerView.addSubview(authorGeoLabel)
        containerView.addSubview(descriptionLabel)

        titleView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
            make.right.equalTo(priceLabel.snp.left).inset(-20)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.top).inset(4)
            make.right.equalToSuperview().inset(20)
        }

        infoLabelsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(10)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.centerX.equalToSuperview()
        }

        additionInfoLabelsStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabelsStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(infoLabelsStackView.snp.width)
        }

        authorStackView.snp.makeConstraints { make in
            make.top.equalTo(additionInfoLabelsStackView.snp.bottom).offset(20)
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

    private func getAditionInfoLabelStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        additionInfoLabels.forEach { infoLabel in
            infoLabel.snp.makeConstraints {$0.height.equalTo(53)}
            stackView.addArrangedSubview(infoLabel)
        }
        return stackView
    }

    private func getInfoLabelStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        infoLabels.forEach { infoLabel in
            infoLabel.snp.makeConstraints {$0.height.equalTo(53)}
            stackView.addArrangedSubview(infoLabel)
        }
        return stackView
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
