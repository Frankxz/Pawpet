//
//  FavoritesViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 07.04.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - Labels
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "", boldString: "Favorite list", font: .systemFont(ofSize: 32))
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    // MARK: - CollectionView
    private let cardCollectionView = CardCollectionView(isHeaderIn: false)

    // MARK: - Ovvderiding properties
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController != self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        cardCollectionView.searchViewControllerDelegate = self
    }
}

// MARK: - UI + Constraints
extension FavoritesViewController {
    private func configurateView() {
        cardCollectionView.cardsCount = 6
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(welcomeLabel)
        view.addSubview(cardCollectionView)


        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(90)
            make.left.equalToSuperview().inset(20)
        }
        cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Delegate
extension FavoritesViewController: SearchViewControllerDelegate {
    func pushToDetailVC() {
        print("Push to DetailVC")
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}
