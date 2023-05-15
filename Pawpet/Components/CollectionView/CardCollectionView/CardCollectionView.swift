//
//  CardCollectionView.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit
protocol SearchViewControllerDelegate: AnyObject {
    func didSelectVariant(breed: String)
    func pushToDetailVC(of publication: Publication)
    func didPetTypeSelected(with petType: PetType)
    func didSearchButtonTapped(with searchText: String)
    func pushToParams()
}

class CardCollectionView: UICollectionView {

    public var searchViewControllerDelegate: SearchViewControllerDelegate?
    private var withHeader = true
    private var isHeaderShort = false
    public var publications: [Publication] = []
    public var isNeedAnimate = true

    private var withHeart: Bool = true
    private var isFavoriteVC: Bool = false

    var headerView: CardCollectionHeaderView?

    // MARK: - INIT
    init (isHeaderIn: Bool = true, isHeaderShort: Bool = false, withHeart: Bool = true, isFavoriteVC: Bool = false) {
        self.withHeader = isHeaderIn
        self.isHeaderShort = isHeaderShort
        self.withHeart = withHeart
        self.isFavoriteVC = isFavoriteVC

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)

        layout.minimumLineSpacing = CardCollectionConstants.lineSpace

        contentInset = UIEdgeInsets(
            top: -40,
            left: CardCollectionConstants.left,
            bottom: 60,
            right: CardCollectionConstants.right)

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
        publications.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseId, for: indexPath) as! CardCollectionViewCell
        let publication = publications[indexPath.row]
        cell.configure(with: publication, withHeart: withHeart)
        cell.deleteCellFromFavorites = { [weak self] in
            if self?.isFavoriteVC ?? false {
                self?.deleteItem(at: indexPath)
            }
        }
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
        let cell = cellForItem(at: indexPath) as! CardCollectionViewCell
        searchViewControllerDelegate?.pushToDetailVC(of: cell.publication!)
        return true
    }
}

// MARK: - Header
extension CardCollectionView {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("Setupping header View")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CardCollectionHeaderView.identifier, for: indexPath) as! CardCollectionHeaderView
        // PARAMS
        header.buttonAction = {
            self.searchViewControllerDelegate?.pushToParams()
            print("Push to params")
        }

        // Type selected
        header.chapterCollectionView.callBack = {
            self.searchViewControllerDelegate?.didPetTypeSelected(with: header.chapterCollectionView.selectedType)
        }

        // Search button tapped
        header.searchButtonAction = {
            self.searchViewControllerDelegate?.didSearchButtonTapped(with: header.searchBar.text ?? "")
        }

        if withHeader {
            header.delegate = self
            header.configure(isShortHeader: isHeaderShort)
        }

        setupHeaderView()
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return withHeader ? CGSize(width: UIScreen.main.bounds.width, height: 260) : CGSize(width: UIScreen.main.bounds.width, height: 40)
    }

    func updateHeaderView() {
        if let headerView = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? CardCollectionHeaderView {
            guard let name = UserManager.shared.user.name else { return }
            headerView.welcomeLabel.setAttributedText(withString: "Hello, ".localize(), boldString: "\(name) ✋🏼", font: .systemFont(ofSize: 28))
        }
    }

    func setupHeaderView() {

        if  let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CardCollectionHeaderView.identifier, for: IndexPath(item: 0, section: 0)) as? CardCollectionHeaderView{
            self.headerView = header
            print("Header View setuped")
        } else {
            print("Could not catch header view")
        }
    }
}

// MARK: - Animation
extension CardCollectionView {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isNeedAnimate { return }

        if indexPath.row > 9 {
            isNeedAnimate = false
            return
        }

        cell.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.05 * Double(indexPath.row),
                       animations: { cell.alpha = 1 })

    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isNeedAnimate = false
    }
}

// MARK: - Header Delegate
extension CardCollectionView: CardCollellectionHeaderViewDelegate {
    func didSelectVariant(breed: String) {
        searchViewControllerDelegate?.didSelectVariant(breed: breed)
    }
}

// MARK: - If In Favorites
extension CardCollectionView {
    func deleteItem(at indexPath: IndexPath) {
        print("DELETE FROM COLLECTIONVIEW")
        publications.remove(at: indexPath.item)
        UserManager.shared.user.isChanged = true
        performBatchUpdates({
            deleteItems(at: [indexPath])
        }, completion: nil)
    }
}

struct CardCollectionConstants {
    static let left: CGFloat = 20
    static let right: CGFloat = 20
    static let lineSpace: CGFloat = 12
    static let itemWidth: CGFloat = UIScreen.main.bounds.width - (left + right)
    static let itemHeight: CGFloat = 130
}
