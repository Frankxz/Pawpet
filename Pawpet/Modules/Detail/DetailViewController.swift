//
//  DetailViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 28.03.2023.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - Main imageView
    private var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .backgroundColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var checkPhotosButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(checkPhotosTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - InfoView
    private let infoView = CardInfoBottomSheetView()

    // MARK: - Buttons
    public lazy var connectButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(connectButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Connect with seller")
        button.layer.cornerRadius = 10
        return button
    }()

    public lazy var saveButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.backgroundColor = .accentColor
        button.layer.cornerRadius = 25
        button.tintColor = .subtitleColor
        return button
    }()

    // MARK: PhotosPageVC
    var photosPageVC: PhotosPageViewController?

    var publication: Publication?

    var isInFavorite: Bool = false

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
    }

    
}

// MARK: - UI + Constraints
extension DetailViewController {
    public func configure(with publication: Publication) {
        self.publication = publication
        if publication.pictures.count != 0 {
            mainImageView.image = publication.pictures.first
            photosPageVC = PhotosPageViewController(images: publication.pictures)
        }
        infoView.configure(with: publication)

        if let favorites = FireStoreManager.shared.user.favorites, favorites.contains(publication.id) {
            print("IN Favorites \(isInFavorite)")
            updateSaveButtonAppearence { _ in }
            print("IN Favorites \(isInFavorite)")
        } else {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
            let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
            saveButton.setImage(image, for: .normal)
            saveButton.tintColor = .subtitleColor
            isInFavorite = false
            print("IN Favorites \(isInFavorite)")
        }
    }

    private func configurateView() {
        setupNavigationAppearence()
        infoView.delegate = self
        view.backgroundColor = .white
        setupConstraints()
    }

    private func setupConstraints() {
        let buttonStackView = getButtonStackView()

        view.addSubview(mainImageView)
        view.addSubview(infoView)
        view.addSubview(buttonStackView)
        view.addSubview(checkPhotosButton)


        mainImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.42)
        }

        infoView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }

        checkPhotosButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(mainImageView)
        }
    }

    private func getButtonStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12

        connectButton.snp.removeConstraints()
        saveButton.snp.makeConstraints{$0.height.width.equalTo(50)}

        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(connectButton)
        return stackView
    }
}

// MARK: - Buttons logic
extension DetailViewController {
    @objc private func connectButtonTapped(_ sender: UIButton) {
        print("Connect..")
    }

    @objc private func checkPhotosTapped(_ sender: UIButton) {
        photosPageVC?.modalPresentationStyle = .fullScreen
        present(photosPageVC!, animated: true)
    }
}

// MARK: - InfoView MainVCDelegate
extension DetailViewController: MainViewControllerDelegate {
    func subviewToFront() {
        view.sendSubviewToBack(checkPhotosButton)
    }

    func subviewToBack() {
        view.bringSubviewToFront(checkPhotosButton)
    }
}

// MARK: Favorite work
extension DetailViewController {
    @objc private func saveButtonTapped() {
        print("saveButtonTapped")
        updateSaveButtonAppearence() { isInFavoriteNow in
            guard let publicationID = self.publication?.id else { return }

            if isInFavoriteNow {
                FireStoreManager.shared.addToFavorites(publicationID: publicationID) { result in
                    switch result {
                    case .success:
                        print("Succesufuly saved to favorites")
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            } else {
                FireStoreManager.shared.removeFromFavorites(publicationID: publicationID) { result in
                    switch result {
                    case .success:
                        print("Succesufuly deleted from favorites")
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
