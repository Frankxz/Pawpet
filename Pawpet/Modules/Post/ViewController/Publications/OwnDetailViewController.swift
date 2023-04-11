//
//  OwnDetailViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 07.04.2023.
//

import UIKit

class OwnDetailViewController: DetailViewController {

    // MARK: - Buttons
    private let editButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Edit", of: .accentColor)
        button.backgroundColor = .infoColor
        button.layer.cornerRadius = 6
        return button
    }()

    private let deleteButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Delete", of: .accentColor)
        button.backgroundColor = .errorColor
        button.layer.cornerRadius = 6
        return button
    }()

    private let archiveButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Archive", of: .accentColor)
        button.backgroundColor = .backgroundColor
        button.layer.cornerRadius = 6
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()

    }
}

// MARK: - UI + Constraints
extension OwnDetailViewController {
    private func setupConstraints() {
        let buttonStackView = getButtonStackView()
        view.addSubview(buttonStackView)
        view.addSubview(editButton)

        saveButton.isHidden = true
        connectButton.isHidden = true

        editButton.snp.removeConstraints()
        archiveButton.snp.removeConstraints()
        deleteButton.snp.removeConstraints()

        editButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(88)
            make.height.equalTo(40)
        }

        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
    }

    private func getButtonStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        stackView.addArrangedSubview(archiveButton)
        stackView.addArrangedSubview(deleteButton)

        return stackView
    }
}
