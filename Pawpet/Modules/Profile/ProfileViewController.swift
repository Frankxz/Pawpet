//
//  ProfileViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit
import FlagPhoneNumber

class ProfileViewController: UIViewController {

    // MARK: - ImageView
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .random()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Labels
    private var infoView = PromptView(with: "Unknown user", and:  "Unknown place")
    private var phoneLabel = LabelView(text: "", viewColor: .accentColor, textColor: .subtitleColor)

    private let phoneTF: FPNTextField = {
        let textField = FPNTextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = .accentColor
        textField.textColor = .subtitleColor
        textField.isUserInteractionEnabled = false
        return textField
    }()

    // MARK: - Buttons
    public lazy var editButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .large)
        let image = UIImage(systemName: "pencil.circle.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .accentColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 17
        return button
    }()

    // MARK: - Labels
    private let favoriteLabel = PromptView(with: "Favorite List", and: "All posts that you marked as liked are displayed here. ")

    // MARK: - CollectionView
    private let cardCollectionView = CardCollectionView(isHeaderIn: false)

    // MARK: - Ovvderiding properties
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController != self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        addButtonsTarget()
        cardCollectionView.searchViewControllerDelegate = self
        cardCollectionView.cardsCount = 6
    }
}

// MARK: - UI + Constraints
extension ProfileViewController {
    private func configurateView() {
        view.backgroundColor = .white
        FireStoreManager.shared.fetchUserData {
            self.infoView.setupTitles(
                title: "\(FireStoreManager.shared.user.name ?? "") \(FireStoreManager.shared.user.surname ?? "")",
                subtitle: "\(FireStoreManager.shared.user.country ?? ""), \(FireStoreManager.shared.user.city ?? "")")
            self.phoneLabel.setupTitle(with: "📞 \(FireStoreManager.shared.getUserPhoneNumber())")
        }

        setupNavigationAppearence()
        setupConstraints()

        phoneTF.set(phoneNumber: (FireStoreManager.shared.getUserPhoneNumber()))
    }

    private func setupConstraints() {
        let infoStackView = getInfoStackView()

        view.addSubview(infoStackView)
        view.addSubview(editButton)
        view.addSubview(favoriteLabel)
        view.addSubview(cardCollectionView)


        infoStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(80)
        }

        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(34)
            make.bottom.equalTo(infoStackView.snp.bottom).offset(10)
            make.left.equalTo(infoStackView.snp.left).offset(80)
        }

        favoriteLabel.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
        }

        cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(favoriteLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }


    private func getLabelStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill

        phoneTF.snp.makeConstraints{$0.height.equalTo(30)}
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(phoneTF)

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
}

// MARK: - Button logic
extension ProfileViewController {
    private func addButtonsTarget() {
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }


    @objc private func editButtonTapped(_ sender: UIButton) {
        print("tik")
        let profileEditVC = ProfileEditViewController()
        profileEditVC.phoneNumber = phoneTF.getFormattedPhoneNumber(format: .National)
        navigationController?.pushViewController(profileEditVC, animated: true)
    }

    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}

// MARK: - Delegate
extension ProfileViewController: SearchViewControllerDelegate {
    func pushToParams() {}

    func pushToDetailVC() {
        print("Push to DetailVC")
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}
