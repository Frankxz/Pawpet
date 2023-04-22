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
        imageView.backgroundColor = .random()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Labels
    private var infoView = PromptView(with: "Robert Miller", and:  "🇷🇺 Russia, Moscow")
    private var phoneLabel = LabelView(text: "📞 +7(913)386-77-00", viewColor: .backgroundColor, textColor: .accentColor.withAlphaComponent(0.8))

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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor

        setupConstraints()
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
            make.top.equalTo(favoriteLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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
}

// MARK: - Button logic
extension ProfileViewController {
    private func addButtonsTarget() {
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }


    @objc private func editButtonTapped(_ sender: UIButton) {
        print("tik")
        let profileEditVC = ProfileEditViewController()
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
