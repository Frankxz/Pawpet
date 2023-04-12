//
//  PhotoCollectionViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    static let reuseId = "PhotoCell"

    // MARK: - UI components
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .backgroundColor
        imageView.layer.cornerRadius = 6
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    public lazy var removeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .bold, scale: .large)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.backgroundColor = .accentColor
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.tintColor = .subtitleColor
        button.clipsToBounds = false

        button.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    public var deleteHandler: (() -> Void)?

    // MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    private func setupConstraints() {
        addSubview(mainImageView)
        addSubview(removeButton)

        mainImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalToSuperview().inset(-6)
            make.right.equalToSuperview().inset(-6)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setupConstraints()
        mainImageView.image = nil
    }

    @objc func removeButtonTapped(_ sender: Any) {
          deleteHandler?()
      }
}

