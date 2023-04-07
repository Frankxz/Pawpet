//
//  ProfileViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - ImageView
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.borderColor = UIColor.subtitleColor.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Labels
    private var infoView = PromptView(with: "Robert Miller", and:  "🇷🇺 Russia, Moscow")
    private var phoneLabel = LabelView(text: "📞 +7(913)386-77-00")

    // MARK: - Buttons
    private var favoritesButton = SectionButton(image: UIImage(systemName: "heart.fill")!, text: "Favorites")

    private var settingsButton = SectionButton(image: UIImage(systemName: "gearshape.fill")!, text: "Settings")

    private var exitButton = SectionButton(image: UIImage(systemName: "xmark.circle.fill")!, text: "Log out", tintColor: .systemRed)

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        addButtonsTarget()
    }
}

// MARK: - UI + Constraints
extension ProfileViewController {
    private func configurateView() {
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupConstraints()
    }

    private func setupConstraints() {
        let infoStackView = getInfoStackView()
        let buttonStackView = getButtonStackView()

        view.addSubview(buttonStackView)
        view.addSubview(infoStackView)

        infoStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(80)
        }

        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(infoStackView.snp.bottom).offset(40)
        }
    }


    private func getLabelStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill

        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(phoneLabel)

        return stackView
    }

    private func getInfoStackView() -> UIStackView {
        let labelStackView = getLabelStackView()

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill

        avatarImageView.snp.makeConstraints { $0.width.height.equalTo(100)
        }
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(labelStackView)

        return stackView
    }

    private func getButtonStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        favoritesButton.snp.makeConstraints { $0.height.equalTo(70) }
        settingsButton.snp.makeConstraints { $0.height.equalTo(70) }
        exitButton.snp.makeConstraints { $0.height.equalTo(70) }

        stackView.addArrangedSubview(favoritesButton)
        stackView.addArrangedSubview(settingsButton)
        stackView.addArrangedSubview(exitButton)

        return stackView
    }
}

// MARK: - Button logic
extension ProfileViewController {
    private func addButtonsTarget() {
        exitButton.addTarget(self, action: #selector(exitButtonTapped(_:)), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
    }

    @objc private func exitButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}
