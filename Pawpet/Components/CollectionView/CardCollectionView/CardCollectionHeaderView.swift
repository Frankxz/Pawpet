//
//  CardCollectionHeaderView.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

protocol CardCollellectionHeaderViewDelegate {
    func didSelectVariant(breed: String)
}

class CardCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CardHeaderView"
    
    // MARK: - SearchBar
    let searchBar = UISearchBar(frame: .zero)

    let searchAlertView = SearchAlertView()
    
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
    var petTypeSelected: (() -> Void)?
    var searchButtonAction: (()-> Void) = {}
    var delegate: CardCollellectionHeaderViewDelegate?
    
    // MARK: - Labels
    public let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "Hello, ".localize(), boldString: "", font: .systemFont(ofSize: 28))
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    // MARK: - CollectionView
    let chapterCollectionView = ChapterCollectionView()

    // MARK: - Skeleton
    private let skeletonView = SkeletonView()

    public var isHeaderAnimated: Bool = false
}

// MARK: - UI + Constraints
extension CardCollectionHeaderView {
    public func configure(isShortHeader: Bool) {
        let searchStackView = getSearchStackView()

        addSubview(searchStackView)
        searchStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(-10)
            make.right.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }

        if !isShortHeader {
            addSubview(chapterCollectionView)
            addSubview(skeletonView)
            addSubview(welcomeLabel)

            chapterCollectionView.clipsToBounds = false
            
            welcomeLabel.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview().offset(20)
            }

            skeletonView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview().offset(20)
                make.height.equalTo(30)
                make.width.equalTo(220)
            }

            chapterCollectionView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(searchStackView.snp.bottom).offset(10)
                make.height.equalTo(140)
            }

            if !isHeaderAnimated {
                welcomeLabel.alpha = 0
                skeletonView.startAnimating()
            }

            UserManager.shared.fetchUserData(completion: { _ in
                self.welcomeLabel.setAttributedText(withString: "Hello, ".localize(), boldString: "\(UserManager.shared.user.name ?? "" ) ✋🏼", font: .systemFont(ofSize: 28))
                if !self.isHeaderAnimated {
                    UIView.animate(withDuration: 0.25) {
                        self.welcomeLabel.alpha = 1
                        self.skeletonView.stopAnimating()
                        self.isHeaderAnimated = true
                    }
                }
            })
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
extension CardCollectionHeaderView: UISearchBarDelegate {
    private func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        let imageOffset = UIOffset(horizontal: 15, vertical: 0)
        let textOffset = UIOffset(horizontal: 5, vertical: 0)
        searchBar.setPositionAdjustment(imageOffset, for: .search)
        searchBar.searchTextPositionAdjustment = textOffset
        searchBar.alpha = 1
        searchBar.placeholder = "Quick search by breed".localize()
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching")
        searchButtonAction()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let allBreeds = BreedManager.shared.allBreeds
        let matchingBreeds = allBreeds.filter { $0.localizedCaseInsensitiveContains(searchText) }
        var searchVariants: [SearchVariant] = []
        for matchingBreed in matchingBreeds {
            searchVariants.append(SearchVariant(petType: .all, breed: matchingBreed))
        }
        self.searchAlertView.update(with: searchVariants)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchAlertView.show(on: self)
        searchAlertView.delegate = self
        BreedManager.shared.getAllBreeds { _ in}
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchAlertView.hide()
    }
}

// MARK: - Button
extension CardCollectionHeaderView {
    @objc func paramsButtonTapped(_ sender: UIButton) {
        buttonAction?()
    }
}

// MARK: - SearchAlertView Delegate
extension CardCollectionHeaderView: SearchAlertViewDelegate {
    func didSelectVariant(breed: String) {
        delegate?.didSelectVariant(breed: breed)
    }
}
