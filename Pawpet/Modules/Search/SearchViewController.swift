//
//  SearchViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Labels
    private let welcomeLabel = PromptView(with: "Hello, Miller !", and: "")

    // MARK: - Segmented control
    private let sectionControl: CustomSegmentedControl = {
        let items = ["Animals", "Accessories", "Feed"]
        let control = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: 320, height: 40), items: items)
        return control
    }()

    // MARK: - CollectionView
    private let chapterCollectionView = ChapterCollectionView()
    private let cardCollectionView = CardCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
    }
}

// MARK: - UI + Constraints
extension SearchViewController {
    private func configurateView() {
        view.backgroundColor = .white
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(sectionControl)
        view.addSubview(welcomeLabel)
        view.addSubview(chapterCollectionView)
        view.addSubview(cardCollectionView)

        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.equalToSuperview().inset(20)
        }

        sectionControl.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
        }

        chapterCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sectionControl.snp.bottom).offset(20)
            make.height.equalTo(140)
        }

        cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chapterCollectionView.snp.bottom).inset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
