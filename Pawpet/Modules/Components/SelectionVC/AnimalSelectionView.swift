//
//  AnimatSelectionViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 22.04.2023.
//

import UIKit

class AnimalSelectionView: UIView {

    // MARK: - PromptView
    public var promptView = PromptView(with: "Select the type of pet.",
                                        and: "This will help users find your listing faster and will also help us provide you with a list of breeds.")

    // MARK: - Button
    public lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK: - CollectionView
    private let chapterCollectionView = ChapterCollectionView()

    init() {
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension AnimalSelectionView {
    private func setupConstraints() {
        addSubview(nextButton)
        addSubview(promptView)
        addSubview(chapterCollectionView)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }

        chapterCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(250)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}
