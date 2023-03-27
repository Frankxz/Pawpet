//
//  AuthButton.swift
//  Pawpet
//
//  Created by Robert Miller on 17.03.2023.
//

import UIKit

class AuthButton: UIButton {

    // MARK: - Public properties
    public let enabledColor = UIColor.accentColor
    public let disabledColor = UIColor.accentColor.withAlphaComponent(0.6)

    // MARK: - Overriding properties
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? enabledColor : disabledColor
        }
    }

    // MARK: - Init
    init() {
        super.init(frame: .zero)

        layer.cornerRadius = 16
        backgroundColor = enabledColor
        addTarget(self, action: #selector(animateTap(_:)), for: .touchUpInside)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Title
    public func setupTitle(for text: String,
                           with font: UIFont = .systemFont(ofSize: 18, weight: .medium),
                           of color: UIColor = .subtitleColor) {
        let title = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
        )
        setAttributedTitle(title, for: .normal)
    }

    // MARK: - Tap Animation
    @objc private func animateTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { finished in
            UIView.animate(withDuration: 0.15) {
                self.transform = .identity
            }
        })
    }
}
