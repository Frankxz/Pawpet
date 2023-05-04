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
    private let refreshControl = UIRefreshControl()

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
        cardCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        hideKeyboardWhenTappedAround()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if FireStoreManager.shared.user.isChanged {
            cardCollectionView.updateHeaderView()
            cardCollectionView.reloadData()
            FireStoreManager.shared.user.isChanged = false
            print("Reloading data")
        }
    }

    @objc private func refreshData(_ sender: Any) {
        fetchData()
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

// MARK: - Fetching data
extension SearchViewController {
    func fetchData() {
        PublicationManager.shared.fetchAllPublications { publications, error  in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            guard let publications = publications else { return }

            if publications.count == self.cardCollectionView.publications.count && FireStoreManager.shared.user.isChanged == false {
                self.cardCollectionView.isNeedAnimate = false
            } else {
                self.cardCollectionView.isNeedAnimate = true
                self.cardCollectionView.publications = publications
                self.cardCollectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
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
