//
//  OptionButton.swift
//  Pawpet
//
//  Created by Robert Miller on 20.03.2023.
//

import UIKit
import Lottie

class OptionButton: UIButton {

    private let customSubtitleLabel = UILabel()

    // MARK: - Public properties
    public let enabledColor = UIColor.systemBlue
    public let disabledColor = UIColor.clear

    // MARK: - Lottie View
    private var animationView: LottieAnimationView?

    // MARK: - Init
    init(systemImage imageName: String = "", size: CGFloat = 56, isLeftAligment: Bool = false, animationName: String = "", withShadows: Bool = true) {
        super.init(frame: .zero)

        layer.cornerRadius = 16

        addTarget(self, action: #selector(animateTap(_:)), for: .touchUpInside)

        if !imageName.isEmpty {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .bold, scale: .large)
            let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
            setImage(image, for: .normal)
        }
        backgroundColor = .accentColor
        tintColor = .subtitleColor

        if withShadows { makeShadows() }

        if animationName != "" {
            setupAnimationView(animationName: animationName)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuring Title
extension OptionButton {
    public func setupTitle(for text: String,
                           with font: UIFont = .systemFont(ofSize: 20, weight: .bold), color: UIColor = .subtitleColor) {
        let color =  color
        let title = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
        )
        setAttributedTitle(title, for: .normal)

    }
}

// MARK: - Configuring Insets
extension OptionButton {
    private func configureInsets() {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 60, trailing: 0)
        configuration.imagePadding = 20
        configuration.titlePadding = 80
        self.configuration = configuration
    }

    public func setupImage(imageName: String) {
        let image = UIImage(named: imageName)
        self.setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        contentMode = .scaleAspectFit
     
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
    }
}
// MARK: - Configuring SubTitle
extension OptionButton {
    public func setupSubtitle(for text: String, with size: CGFloat, color: UIColor = .subtitleColor) {
        customSubtitleLabel.font = .systemFont(ofSize: size, weight: .bold)
        customSubtitleLabel.text = text
        customSubtitleLabel.textAlignment = .center
        customSubtitleLabel.textColor = color

        addSubview(customSubtitleLabel)
        customSubtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        configureInsets()
    }
}

// MARK: - Configuring shadows
extension OptionButton {
    public func makeShadows() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 3

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

// MARK: - Tap Animation
extension OptionButton {
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

// MARK: - Constraints
extension OptionButton {
    private func setupAnimationView(animationName: String) {
        animationView = LottieAnimationView(name: animationName)
        guard let animationView = animationView else {return}

        animationView.loopMode = .autoReverse
        animationView.layer.allowsEdgeAntialiasing = true
        animationView.contentMode = .scaleAspectFill

        addSubview(animationView)

        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        animationView.play()
    }
}


