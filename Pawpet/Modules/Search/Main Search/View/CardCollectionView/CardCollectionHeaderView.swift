//
//  CardCollectionHeaderView.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

class CardCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CardHeaderView"

    // MARK: - ImageView
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "pawpet_square_logo")
        return imageView
    }()
    
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
    public let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "Hello, ", boldString: "", font: .systemFont(ofSize: 32))
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    // MARK: - Segmented control
    private let sectionControl: CustomSegmentedControl = {
        let items = ["Animals", "Accessories", "Feed"]
        let control = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width - (48 + 54)), height: 40), items: items)
        return control
    }()

    // MARK: - CollectionView
    private let chapterCollectionView = ChapterCollectionView()

    // MARK: - Skeleton
    private let skeletonView = SkeletonView()

    public var isHeaderAnimated: Bool = false
}

// MARK: - UI + Constraints
extension CardCollectionHeaderView {
    public func configure() {
        let searchStackView = getSearchStackView()

        addSubview(searchStackView)
        addSubview(sectionControl)
        addSubview(welcomeLabel)
        addSubview(chapterCollectionView)
        addSubview(skeletonView)
        addSubview(logoImageView)

        chapterCollectionView.clipsToBounds = false

        welcomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }

        logoImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalTo(60)
        }

        skeletonView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
            make.width.equalTo(220)
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

        if !isHeaderAnimated {
            welcomeLabel.alpha = 0
            skeletonView.startAnimating()
        }
        FireStoreManager.shared.fetchUserData(completion: { _ in
            self.welcomeLabel.setAttributedText(withString: "Hello, ", boldString: "\(FireStoreManager.shared.user.name ?? "" ) ✋🏼", font: .systemFont(ofSize: 32))
            if !self.isHeaderAnimated {
                UIView.animate(withDuration: 0.25) {
                    self.welcomeLabel.alpha = 1
                    self.skeletonView.stopAnimating()
                    self.isHeaderAnimated = true
                }
            }
        })

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
