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
    func pushToDetailVC() {
        print("Push to DetailVC")
        //hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}
