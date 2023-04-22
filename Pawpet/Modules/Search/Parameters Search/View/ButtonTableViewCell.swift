//
//  ButtonTableViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 22.04.2023.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
//        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupButton() {
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
