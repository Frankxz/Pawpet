//
//  SectionButton.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class SectionButton: UIButton {

    private lazy var icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.backgroundColor = .backgroundColor
        image.tintColor = .accentColor


        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
       image.preferredSymbolConfiguration = imageConfig
        
        return image
    }()

    private var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.accentColor
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    // MARK: - Init
    init(image: UIImage, text: String = "", tintColor: UIColor = .accentColor) {
        super.init(frame: .zero)
        backgroundColor = .clear

        icon.image = image
        mainLabel.text = text
        icon.tintColor = tintColor

        setupConstraints()
        addTarget(self, action: #selector(animateTap(_:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension SectionButton {
    private func setupConstraints() {
        addSubview(icon)
        addSubview(mainLabel)

        icon.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.left.centerY.equalToSuperview()
        }

        mainLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(20)
        })
    }
}

// MARK: - Tap Animation
extension SectionButton {
    @objc private func animateTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            self.icon.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { finished in
            UIView.animate(withDuration: 0.15) {
                self.icon.transform = .identity
            }
        })
    }
}
