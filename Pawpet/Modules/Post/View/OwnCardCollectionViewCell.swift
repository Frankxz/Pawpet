//
//  OwnCardCollectionViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 07.04.2023.
//

import UIKit

class OwnCardCollectionViewCell: CardCollectionViewCell {
    // MARK: - Buttons
    private let editButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Edit")
        button.backgroundColor = .systemYellow
        return button
    }()

    private let deleteButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Delete")
        button.backgroundColor = .errorColor
        return button
    }()

    private let archiveButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Archive")
        button.backgroundColor = .backgroundColor
        return button
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension OwnCardCollectionViewCell {
    private func setupConstraints() {
        let buttonStackView = getButtonStackView()

        addSubview(getButtonStackView())

        buttonStackView.snp.makeConstraints { make in
            
        }
    }

    private func getButtonStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20

        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(archiveButton)
        stackView.addArrangedSubview(deleteButton)

        return stackView
    }
}
