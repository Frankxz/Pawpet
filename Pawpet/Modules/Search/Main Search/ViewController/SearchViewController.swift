//
//  SearchViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - CollectionView
    private let cardCollectionView = CardCollectionView()

    // MARK: - Ovvderiding properties
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController != self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }

    // MARK: - Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        cardCollectionView.searchViewControllerDelegate = self
        hideKeyboardWhenTappedAround()
        let petType = PetType.cat
        print(petType.getName())
    }

    override func viewWillAppear(_ animated: Bool) {
        cardCollectionView.updateHeaderView()
        FireStoreManager.shared.fetchAllPublications { publications in
            if publications.count == self.cardCollectionView.publications.count {
                self.cardCollectionView.isNeedAnimate = false
            } else {
                self.cardCollectionView.isNeedAnimate = true
            }
            self.cardCollectionView.publications = publications
            self.cardCollectionView.reloadData()
        }
    }
}

// MARK: - UI + Constraints
extension SearchViewController {
    private func configurateView() {
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(cardCollectionView)
        cardCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Delegate
extension SearchViewController: SearchViewControllerDelegate {
    func pushToDetailVC(of publication: Publication) {
        print("Push to DetailVC")
        let detailVC = DetailViewController()
        detailVC.configure(with: publication)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func pushToParams() {
        navigationController?.pushViewController(ParametersViewController(), animated: true)
    }
}
