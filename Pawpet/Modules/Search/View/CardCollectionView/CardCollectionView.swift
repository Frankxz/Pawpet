//
//  CardCollectionView.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit
 protocol SearchViewControllerDelegate: AnyObject {
    func pushToDetailVC()
}

class CardCollectionView: UICollectionView {

    var searchViewControllerDelegate: SearchViewControllerDelegate?

    // MARK: - INIT
    init () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)

        layout.minimumLineSpacing = ChapterCollectionConstants.lineSpace

        contentInset = UIEdgeInsets(
            top: -20,
            left: ChapterCollectionConstants.left,
            bottom: 0,
            right: ChapterCollectionConstants.right)

        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        dataSource = self

        self.backgroundColor = .clear
        register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseId)
        register(CardCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CardCollectionHeaderView.identifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource
extension CardCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseId, for: indexPath) as! CardCollectionViewCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

// MARK: - Layout
extension CardCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CardCollectionConstants.itemWidth,
                      height: CardCollectionConstants.itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        searchViewControllerDelegate?.pushToDetailVC()
        return true
    }
}

// MARK: - Header
extension CardCollectionView {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CardCollectionHeaderView.identifier, for: indexPath) as! CardCollectionHeaderView
        header.configure()
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 250)
    }
}

struct CardCollectionConstants {
    static let left: CGFloat = 20
    static let right: CGFloat = 20
    static let lineSpace: CGFloat = 20
    static let itemWidth: CGFloat = UIScreen.main.bounds.width - (left + right)
    static let itemHeight: CGFloat = 120
}
