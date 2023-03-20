//
//  PromptView.swift
//  Pawpet
//
//  Created by Robert Miller on 20.03.2023.
//

import UIKit

class PromptView: UIView {

    // MARK: - Labels
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please, choose"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        label.numberOfLines = 0
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "This is important for further registration."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .subtitleColor
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    init(with title: String, and subtitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PromptView {
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        backgroundColor = .clear
    }
}
