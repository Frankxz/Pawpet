//
//  LabelView.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class LabelView: UIView {

    // MARK: - Label
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.subtitleColor
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    init(
        text: String,
        size: CGFloat = 14,
        weight: UIFont.Weight = .bold,
        aligment: NSTextAlignment = .left,
        viewColor: UIColor = .accentColor
    ) {
        super.init(frame: .zero)

        mainLabel.text = text
        mainLabel.font = .systemFont(ofSize: size, weight: weight)
        mainLabel.textAlignment = aligment

        backgroundColor = viewColor
        layer.cornerRadius = 10

        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(8)
        }
    }
}
