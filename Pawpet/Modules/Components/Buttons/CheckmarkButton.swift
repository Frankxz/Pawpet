//
//  SectionButton.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class CheckmarkButton: UIView {
    lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        return button
    }()

    var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.accentColor
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
    }()

    // MARK: - Init
    init(text: String = "") {
        super.init(frame: .zero)
        backgroundColor = .backgroundColor
        layer.cornerRadius = 8
        mainLabel.text = text
        setupConstraints()
        button.addTarget(self, action: #selector(animateTap(_:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension CheckmarkButton {
    private func setupConstraints() {
        backgroundColor = .backgroundColor
        layer.cornerRadius = 6
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5

        button.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(button)



        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Tap Animation
extension CheckmarkButton {
    @objc private func animateTap(_ sender: UIButton) {
        print("TAPPED")
        UIView.animate(withDuration: 0.15, animations: {
            self.button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { finished in
            UIView.animate(withDuration: 0.15) {
                self.button.transform = .identity
            }
        })

        button.isSelected ? setUnselected() : setSelected()
    }

    private func setSelected() {
        button.isSelected = true
        UIView.animate(withDuration: 0.25) {
            self.button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
            self.button.tintColor = .systemBlue
        }
    }

    private func setUnselected() {
        button.isSelected = false
        UIView.animate(withDuration: 0.25) {
            self.button.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button.tintColor = .subtitleColor
        }
    }
}
