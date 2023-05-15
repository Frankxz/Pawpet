//
//  SkeletonView.swift
//  Pawpet
//
//  Created by Robert Miller on 30.04.2023.
//

import UIKit

class SkeletonView: UIView {

    private var gradientLayer: CAGradientLayer!
    private var animation: CABasicAnimation!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
        setupAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 10
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1.0).cgColor,
            UIColor(white: 0.95, alpha: 1.0).cgColor,
            UIColor(white: 0.85, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
    }

    private func setupAnimation() {
        animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.25
    }

    func startAnimating() {
        self.alpha = 1
        gradientLayer.add(animation, forKey: "skeletonAnimation")
    }

    func stopAnimating() {
        self.alpha = 0
        gradientLayer.removeAnimation(forKey: "skeletonAnimation")
    }
}

