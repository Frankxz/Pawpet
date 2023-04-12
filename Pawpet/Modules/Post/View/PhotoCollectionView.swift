//
//  PhotoCollectionView.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit

class PhotoCollectionView: UICollectionView {

    // MARK:  Buttons
    public lazy var addButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .accentColor
        return button
    }()

    public var images: [UIImage] = []

    // MARK: - INIT
    init () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)

        layout.minimumLineSpacing = PhotosCollectionConstants.lineSpace

        contentInset = UIEdgeInsets(
            top: 10,
            left: PhotosCollectionConstants.left,
            bottom: 0,
            right: PhotosCollectionConstants.right)

        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        dataSource = self

        self.backgroundColor = .clear
        register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource
extension PhotoCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as! PhotoCollectionViewCell
        print("row: \(indexPath.row)")
        print("section: \(indexPath.section)")
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.mainImageView.removeFromSuperview()
            cell.removeButton.removeFromSuperview()
            cell.backgroundColor = .backgroundColor
            cell.layer.cornerRadius = 6
            cell.addSubview(addButton)
            addButton.snp.makeConstraints { make in
                make.centerY.centerX.equalToSuperview()
                make.height.width.equalTo(80)
            }
        } else {
            cell.mainImageView.image = images[indexPath.row - 1]
        }

        cell.deleteHandler = { [weak self] in
                 guard let self = self else { return }
                 self.performBatchUpdates({
                     self.images.remove(at: indexPath.item - 1)
                     self.deleteItems(at: [indexPath])
                 }, completion: {
                     _ in self.reloadData()
                 })
             }

        return cell
    }
}

// MARK: - Layout
extension PhotoCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PhotosCollectionConstants.itemWidth,
                      height: PhotosCollectionConstants.itemHeight)
    }
}


struct PhotosCollectionConstants {
    static let left: CGFloat = 20
    static let right: CGFloat = 20
    static let lineSpace: CGFloat = 10
    static let itemWidth: CGFloat = 80
    static let itemHeight: CGFloat = 80
}

