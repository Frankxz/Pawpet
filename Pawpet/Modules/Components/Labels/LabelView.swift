//
//  LabelView.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class LabelView: UIView {

    private var currentIndex = 0
    private var currentText: String = ""

    // MARK: - Label
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.subtitleColor
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel = UILabel()

    // MARK: - Init
    init(
        text: String,
        subtitle: String = "",
        size: CGFloat = 14,
        weight: UIFont.Weight = .bold,
        aligment: NSTextAlignment = .left,
        viewColor: UIColor = .accentColor,
        textColor: UIColor = .subtitleColor
    ) {
        super.init(frame: .zero)

        mainLabel.text = text
        mainLabel.font = .systemFont(ofSize: size, weight: weight)
        mainLabel.textAlignment = aligment
        mainLabel.textColor = textColor

        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: size, weight: .thin)
        subtitleLabel.textAlignment = aligment
        subtitleLabel.textColor = textColor

        backgroundColor = viewColor
        layer.cornerRadius = 6

        setupConstraints(withSubtitle: !subtitle.isEmpty)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints(withSubtitle: Bool = false) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5

        if withSubtitle {stackView.addArrangedSubview(subtitleLabel)}
        stackView.addArrangedSubview(mainLabel)
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(8)
        }
    }

    func animate(newText: String, characterDelay: TimeInterval) {
        currentText = newText
        currentIndex = 0
        mainLabel.text = ""

        Timer.scheduledTimer(withTimeInterval: characterDelay, repeats: true) { timer in
            if self.currentIndex < self.currentText.count {
                let index = self.currentText.index(self.currentText.startIndex, offsetBy: self.currentIndex)
                let letter = String(self.currentText[index])
                self.mainLabel.text?.append(letter)
                self.currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}