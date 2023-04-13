//
//  PromptView.swift
//  Pawpet
//
//  Created by Robert Miller on 20.03.2023.
//

import UIKit

class PromptView: UIView {

    // MARK: - Labels
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please, choose"
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        label.numberOfLines = 0
        return label
    }()

    public var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "This is important for further registration."
        label.textColor = .subtitleColor
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    init(with title: String, and subtitle: String, titleSize: CGFloat = 34, subtitleSize: CGFloat = 16, spacing: CGFloat = 0, aligment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.textAlignment = aligment
        titleLabel.font = UIFont.systemFont(ofSize: titleSize, weight: .bold)

        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = aligment
        subtitleLabel.font = UIFont.systemFont(ofSize: subtitleSize, weight: .medium)
        setupView(aligment: aligment, spacing: spacing)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PromptView {
    private func setupView(aligment: NSTextAlignment, spacing: CGFloat) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        aligment == .left ? (stackView.alignment = .leading) : (stackView.alignment = .center)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        backgroundColor = .clear
    }

    public func setupTitles(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
