//
//  ProfileSkeletonView.swift
//  Pawpet
//
//  Created by Robert Miller on 30.04.2023.
//

import UIKit

class ProfileSkeletonView: UIView {

    let avatarSkeletonView = SkeletonView()
    let countrySkeletonView = SkeletonView()
    let phoneSkeletonView = SkeletonView()
    let infoSkeletonView = SkeletonView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
     
    }

    private func setupSkeletonView() {
        let labelSkeletonStackView = UIStackView()

        labelSkeletonStackView.axis = .vertical
        labelSkeletonStackView.spacing = 6
        labelSkeletonStackView.distribution = .fill

        phoneSkeletonView.snp.makeConstraints{$0.height.equalTo(30)}

        labelSkeletonStackView.addArrangedSubview(infoSkeletonView)
        labelSkeletonStackView.addArrangedSubview(countrySkeletonView)
        labelSkeletonStackView.addArrangedSubview(phoneSkeletonView)


        let mainSkeletonStackView = UIStackView()
        mainSkeletonStackView.axis = .horizontal
        mainSkeletonStackView.spacing = 20
        mainSkeletonStackView.distribution = .fill

        avatarSkeletonView.snp.makeConstraints { $0.width.height.equalTo(100)
        }

        mainSkeletonStackView.addArrangedSubview(avatarSkeletonView)
        mainSkeletonStackView.addArrangedSubview(labelSkeletonStackView)

        self.addSubview(mainSkeletonStackView)
        mainSkeletonStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        avatarSkeletonView.startAnimating()
        phoneSkeletonView.startAnimating()
        countrySkeletonView.startAnimating()
        infoSkeletonView.startAnimating()
    }

    public func show(on targetView: UIView) {
        targetView.addSubview(self)

        self.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(80)
        }

        self.alpha = 1
        avatarSkeletonView.startAnimating()
        phoneSkeletonView.startAnimating()
        countrySkeletonView.startAnimating()
        infoSkeletonView.startAnimating()
    }

    public func hide() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        }
        avatarSkeletonView.stopAnimating()
        phoneSkeletonView.stopAnimating()
        countrySkeletonView.stopAnimating()
        infoSkeletonView.stopAnimating()
        self.removeFromSuperview()
    }
}

