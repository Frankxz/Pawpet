//
//  CardInfoBottomSheetView.swift
//  Pawpet
//
//  Created by Robert Miller on 30.03.2023.
//

import UIKit

class CardInfoBottomSheetView: BottomSheetView{
    // MARK: - Properties
    private let titleView = PromptView(with: "Husky", and: "Dog")
    
    private let infoLabels = [
        LabelView(text: "2 y.", subtitle: "Age", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
        LabelView(text: "Male", subtitle: "Gender", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
        LabelView(text: "3.5 kg", subtitle: "Weight", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
        LabelView(text: "Yes", subtitle: "Vacine", aligment: .center, viewColor: .backgroundColor, textColor: .accentColor),
    ]

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum bla bla bla ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .justified
        return label
    }()

    private var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.subtitleColor.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let authorLabel = PromptView(with: "Maybe Baby", and: "Owner", titleSize: 22, subtitleSize: 14)

    private let authorGeoLabel: UILabel = {
        let label = UILabel()
        label.text = "850 m."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()

    private lazy var aboutGreedButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let image = UIImage(systemName: "info.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
       // button.backgroundColor = .accentColor
        button.layer.cornerRadius = 15
        button.tintColor = .systemYellow.withAlphaComponent(0.95)
        return button
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
    private func setupInfoView() {
        let infoLabelsStackView = getInfoLabelStackView()
        let authorStackView = getAuthorStackView()

        containerView.addSubview(titleView)
        containerView.addSubview(infoLabelsStackView)
        containerView.addSubview(authorStackView)
        containerView.addSubview(authorGeoLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(aboutGreedButton)

        titleView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
        }

        aboutGreedButton.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.top)
            make.right.equalToSuperview().inset(20)
            make.height.width.equalTo(30)
        }

        infoLabelsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        authorStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabelsStackView.snp.bottom).offset(20)
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

    private func getInfoLabelStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        infoLabels.forEach { infoLabel in
            infoLabel.snp.makeConstraints {$0.height.equalTo(50)}
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
