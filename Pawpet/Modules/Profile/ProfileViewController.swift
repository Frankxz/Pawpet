//
//  ProfileViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit
import Firebase
import FlagPhoneNumber

class ProfileViewController: UIViewController {

    // MARK: - ImageView
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .backgroundColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Labels
    private var infoView = PromptView(with: "Unknown user", and:  "Unknown place")
    
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
    private let favoriteLabel = PromptView(with: "Favorite List", and: "All posts that you marked as liked are displayed here.")

    // MARK: - CollectionView
    private let cardCollectionView = CardCollectionView(isHeaderIn: false, isFavoriteVC: true)

    // MARK: - StackView
    private var infoStackView = UIStackView()
    private var infoSkeletonView = ProfileSkeletonView()

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
        infoView.titleLabel.minimumScaleFactor = 0.7
        infoView.titleLabel.adjustsFontSizeToFitWidth = true
    }

    override func viewWillAppear(_ animated: Bool) {
        if  FireStoreManager.shared.user.isChanged {
            self.infoStackView.alpha = 0
            self.editButton.alpha = 0
            infoSkeletonView.show(on: view)

            FireStoreManager.shared.fetchAvatarImage(imageView: avatarImageView) {}

            FireStoreManager.shared.fetchUserData { _ in
                self.infoView.setupTitles(
                    title: "\(FireStoreManager.shared.user.name ?? "") \(FireStoreManager.shared.user.surname ?? "")",
                    subtitle: "\(FireStoreManager.shared.user.country ?? ""), \(FireStoreManager.shared.user.city ?? "")")
                self.phoneTF.set(phoneNumber: (FireStoreManager.shared.getUserPhoneNumber()))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    UIView.animate(withDuration: 0.25) {
                        self.infoStackView.alpha = 1
                        self.editButton.alpha = 1
                        self.infoSkeletonView.hide()
                        FireStoreManager.shared.user.isChanged = false
                    }
                }
            }

            PublicationManager.shared.fetchFavoritePublications { result in
                switch result {
                case .success(let favorites):
                    print("FAVORITE POSTS COUNT: \(favorites.count)")
                    self.cardCollectionView.publications = favorites
                    self.cardCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - UI + Constraints
extension ProfileViewController {
    private func configurateView() {
        view.backgroundColor = .white
        setupNavigationAppearence()
        setupConstraints()
    }

    private func setupConstraints() {
        infoStackView = getInfoStackView()

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
            make.left.right.equalToSuperview().inset(20)
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
        profileEditVC.avatarImageView.image = avatarImageView.image
        profileEditVC.phoneNumber = phoneTF.getFormattedPhoneNumber(format: .National)
        navigationController?.pushViewController(profileEditVC, animated: true)
    }
}

// MARK: - Delegate
extension ProfileViewController: SearchViewControllerDelegate {
    func pushToDetailVC(of publication: Publication) {
        print("Push to DetailVC")
        let detailVC = DetailViewController()
        detailVC.configure(with: publication)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func pushToParams() {}
}
