//
//  CardCollectionHeaderView.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

class CardCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CardHeaderView"

    
    // MARK: - SearchBar
    private let searchBar = UISearchBar(frame: .zero)

    // MARK: - Button
    public lazy var paramsButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        let image = UIImage(systemName: "slider.horizontal.3", withConfiguration: imageConfig)
        button.addTarget(self, action: #selector(paramsButtonTapped(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.backgroundColor = .accentColor
        button.layer.cornerRadius = 6
        button.tintColor = .subtitleColor
        return button
    }()

    var buttonAction: (() -> Void)?

    // MARK: - Labels
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "Hello, ", boldString: "Miller ✋🏼", font: .systemFont(ofSize: 32))
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    // MARK: - Segmented control
    private let sectionControl: CustomSegmentedControl = {
        let items = ["Animals", "Accessories", "Feed"]
        let control = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width - (48 + 54)), height: 40), items: items)
        return control
    }()

    // MARK: - ImageView
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.subtitleColor.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .random()
        return imageView
    }()

    // MARK: - CollectionView
    private let chapterCollectionView = ChapterCollectionView()
}

// MARK: - UI + Constraints
extension CardCollectionHeaderView {
    public func configure() {
        FireStoreManager.shared.fetchUserData(completion: {
            self.welcomeLabel.setAttributedText(withString: "Hello, ", boldString: "\(FireStoreManager.shared.user.name ?? "" ) ✋🏼", font: .systemFont(ofSize: 32))
        })
        
        let searchStackView = getSearchStackView()

        addSubview(searchStackView)
        addSubview(avatarImageView)
        addSubview(sectionControl)
        addSubview(welcomeLabel)
        addSubview(chapterCollectionView)

        chapterCollectionView.clipsToBounds = false

        welcomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        searchStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(-10)
            make.right.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
        }

        sectionControl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(searchStackView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }

        chapterCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sectionControl.snp.bottom).offset(10)
            make.height.equalTo(140)
        }

        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(welcomeLabel.snp.top)
            make.right.equalToSuperview()
        }
    }

    private func getSearchStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.distribution = .fill

        paramsButton.snp.makeConstraints {$0.height.width.equalTo(48)}

        setSearchBar()

        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(paramsButton)
        stackView.clipsToBounds = false

        return stackView
    }
}

// MARK: - SearchBar setup
extension CardCollectionHeaderView {
    private func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        let imageOffset = UIOffset(horizontal: 15, vertical: 0)
        let textOffset = UIOffset(horizontal: 5, vertical: 0)
        searchBar.setPositionAdjustment(imageOffset, for: .search)
        searchBar.searchTextPositionAdjustment = textOffset

        searchBar.placeholder = "Search your dream pet"
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
    }
}

// MARK: - Button
extension CardCollectionHeaderView {
    @objc func paramsButtonTapped(_ sender: UIButton) {
        buttonAction?()
    }
}
