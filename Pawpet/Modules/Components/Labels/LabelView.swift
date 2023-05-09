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
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.subtitleColor
        label.numberOfLines = 0
        return label
    }()

    let subtitleLabel = UILabel()

    // MARK: - Init
    init(
        text: String,
        subtitle: String = "",
        size: CGFloat = 14,
        weight: UIFont.Weight = .bold,
        aligment: NSTextAlignment = .left,
        viewColor: UIColor = .accentColor,
        textColor: UIColor = .subtitleColor,
        edgeOffset: CGFloat = 8
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

        setupConstraints(withSubtitle: !subtitle.isEmpty, edgeOffset: edgeOffset)
    }

    init(prompt: String, value: String, isGreenText: Bool = false) {
        super.init(frame: .zero)
        mainLabel.text = value
        mainLabel.font = .systemFont(ofSize: 14, weight: .bold)
        mainLabel.textAlignment = .center
        mainLabel.textColor = isGreenText ? .systemGreen : .accentColor

        subtitleLabel.text = prompt.localize()
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .thin)
        
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .accentColor

        backgroundColor = .backgroundColor
        layer.cornerRadius = 6

        setupConstraints(withSubtitle: true, edgeOffset: 8)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension LabelView {
    private func setupConstraints(withSubtitle: Bool = false, edgeOffset: CGFloat) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5

        if withSubtitle {stackView.addArrangedSubview(subtitleLabel)}
        stackView.addArrangedSubview(mainLabel)

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(edgeOffset)
        }
    }

    func setupTitle(with text: String,
                    and subtitle: String = "") {
        mainLabel.text = text.localize()
        if !subtitle.isEmpty {
            subtitleLabel.text = subtitle.localize()
        }
    }

    func setupColors(viewColor: UIColor, textColor: UIColor) {
        backgroundColor = viewColor
        mainLabel.textColor = textColor
    }
}

// MARK: - Animate
extension LabelView {
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
