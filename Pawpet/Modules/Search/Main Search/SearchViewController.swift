//
//  SearchViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 09.05.2023.
//

import UIKit

class SearchViewController: UIViewController {

    let cardCollectionView = CardCollectionView(isHeaderIn: false)
    var searchText: String = ""
    var isFromDetail: Bool

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupNavigationTitle()
        setupNavigationAppearence()
        cardCollectionView.searchViewControllerDelegate = self
    }

    init(isFromDetail: Bool = false) {
        self.isFromDetail = isFromDetail
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        if isFromDetail { return }
        PublicationManager.shared.fetchPublicationsByBreed(searchText) { result in
            switch result {
            case .success(let fetchedPublications):
                self.cardCollectionView.publications = fetchedPublications
                self.cardCollectionView.isNeedAnimate = true
                self.cardCollectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func setupConstraints() {
        view.addSubview(cardCollectionView)
        cardCollectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }


    private func setupNavigationTitle() {
        let titleColor = UIColor.accentColor.withAlphaComponent(0.8)
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: titleFont
        ]

        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title  = "\(searchText)"
    }
}


// MARK: - Delegate
extension SearchViewController: SearchViewControllerDelegate {
    func didSelectVariant(breed: String) {}

    func didSearchButtonTapped(with searchText: String) { }

    func didPetTypeSelected(with petType: PetType) { }

    func pushToDetailVC(of publication: Publication) {
        print("Push to DetailVC")
        let detailVC = DetailViewController()
        detailVC.configure(with: publication)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func pushToParams() {}
}
