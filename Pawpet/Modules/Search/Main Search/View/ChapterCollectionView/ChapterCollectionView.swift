//
//  ChapterCollectionView.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class ChapterCollectionView: UICollectionView {

    var lastIndexActive: IndexPath = [0, 0]

    // MARK: - INIT
    init () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)

        layout.minimumLineSpacing = ChapterCollectionConstants.lineSpace

        contentInset = UIEdgeInsets(
            top: 0,
            left: ChapterCollectionConstants.left,
            bottom: 0,
            right: ChapterCollectionConstants.right)

        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        dataSource = self

        self.backgroundColor = .clear
        register(ChapterCollectionViewCell.self, forCellWithReuseIdentifier: ChapterCollectionViewCell.reuseId)

        selectItem(at: lastIndexActive, animated: true, scrollPosition: [])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource
extension ChapterCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: ChapterCollectionViewCell.reuseId, for: indexPath) as! ChapterCollectionViewCell
        if indexPath == lastIndexActive {
            cell.mainImageView.backgroundColor = .accentColor
            cell.nameLabel.textColor = .accentColor
        }
        return cell
    }
}

// MARK: - Layout
extension ChapterCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ChapterCollectionConstants.itemWidth,
                      height: ChapterCollectionConstants.itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if lastIndexActive != indexPath {
            let cell = collectionView.cellForItem(at: indexPath) as! ChapterCollectionViewCell
            UIView.animate(withDuration: 0.3) {
                cell.mainImageView.backgroundColor = .accentColor
                cell.nameLabel.textColor = .accentColor
            }

            guard let lastSelectedCell = collectionView.cellForItem(at: lastIndexActive) as? ChapterCollectionViewCell else { return }
            UIView.animate(withDuration: 0.2) {
                lastSelectedCell.mainImageView.backgroundColor = .backgroundColor
                lastSelectedCell.nameLabel.textColor = .subtitleColor
            }
            lastIndexActive = indexPath
        }
    }
}


struct ChapterCollectionConstants {
    static let left: CGFloat = 0
    static let right: CGFloat = 20
    static let lineSpace: CGFloat = 10
    static let itemWidth: CGFloat = 80
    static let itemHeight: CGFloat = 120
}