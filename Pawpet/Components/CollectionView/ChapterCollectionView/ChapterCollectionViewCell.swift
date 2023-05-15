//
//  ChapterCollectionViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {

    static let reuseId = "ChapterCell"
    var petType: PetType?

    // MARK: - UI components
    let squareView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 6
        return view
    }()

    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .subtitleColor
        label.textAlignment = .center
        label.text = "Test"
        return label
    }()

    // MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(squareView)
        addSubview(nameLabel)
        squareView.addSubview(mainImageView)

        squareView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        mainImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(squareView.snp.bottom).offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        mainImageView.image = nil
    }

    func configure(type: PetType) {
        self.petType = type
        let imageName =  "\(type)"
        nameLabel.text = type.getNamePlural()
        if petType == .all {
            mainImageView.image = UIImage(systemName: "square.grid.2x2") //
        } else {
            mainImageView.image = UIImage(named: imageName )
        }
        mainImageView.tintColor = .accentColor.withAlphaComponent(0.8)
        mainImageView.backgroundColor = .clear
    }

    func setSelected() {
        UIView.animate(withDuration: 0.25) {
            self.mainImageView.tintColor = .white
            self.mainImageView.backgroundColor = .accentColor
            self.squareView.backgroundColor = .accentColor
            self.nameLabel.textColor = .accentColor
        }
    }

    func setUnselected() {
        UIView.animate(withDuration: 0.25) {
            self.mainImageView.tintColor = .accentColor.withAlphaComponent(0.8)
            self.squareView.backgroundColor = .backgroundColor
            self.mainImageView.backgroundColor = .backgroundColor
            self.nameLabel.textColor = .subtitleColor
        }
    }
}
