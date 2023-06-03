//
//  PostViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit
import Lottie
import Firebase

class PublicationsViewController: UIViewController {

    // MARK: - In case < 0 posts

    // MARK: Lottie View
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "SadDog")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: Labels
    private let noPostsLabel = PromptView(with: "Oops, here is no posts yet... ", and: "It's time to add, try it, it's very easy!", aligment: .center)

    // MARK: Buttons
    private lazy var postButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Add post".localize())
        return button
    }()

    private var plugStackView = UIStackView()

    // MARK: - In case > 0 posts
    
    // MARK:  Labels
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "", boldString: "My Publications".localize(), font: .systemFont(ofSize: 32))
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    // MARK:  CollectionView
    private let cardCollectionView = CardCollectionView(isHeaderIn: false, withHeart: false)
    private let refreshControl = UIRefreshControl()
    
    // MARK:  Buttons
    public lazy var addButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.backgroundColor = .accentColor
        button.layer.cornerRadius = 16
        button.tintColor = .subtitleColor
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK:  Ovvderiding properties
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController != self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        cardCollectionView.searchViewControllerDelegate = self
        cardCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("PublicationsViewController viewWillAppear")
        if UserManager.shared.user.isChanged {
            fetchData()
        }
    }

    @objc private func refreshData(_ sender: Any) {
        fetchData()
    }
}

// MARK: - Fetching data
extension PublicationsViewController {
    func fetchData() {
        PublicationManager.shared.fetchPublications() { fetchedPublications, error  in
            if error != nil {
                self.setupViewAccordingToPosts(publications: [])
            }

            guard let fetchedPublications = fetchedPublications  else { return }

            if fetchedPublications.count == self.cardCollectionView.publications.count {
                self.cardCollectionView.isNeedAnimate = false
            } else {
                self.cardCollectionView.isNeedAnimate = true
                self.cardCollectionView.publications = fetchedPublications
                self.cardCollectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.setupViewAccordingToPosts(publications: fetchedPublications)
        }
    }
}
// MARK: - UI + Constraints in case posts = 0
extension PublicationsViewController {
    private func setupViewAccordingToPosts(publications: [Publication]) {
        removeAllFromSupperView()
        if publications.isEmpty {
            setupConstraintsForPlugView()
        } else {
            setupConstraints()
        }
    }

    private func removeAllFromSupperView() {
        plugStackView.snp.removeConstraints()
        plugStackView.removeFromSuperview()
        plugStackView = getPlugStackView()
        postButton.snp.removeConstraints()
        postButton.removeFromSuperview()
        welcomeLabel.snp.removeConstraints()
        welcomeLabel.removeFromSuperview()
        cardCollectionView.snp.removeConstraints()
        cardCollectionView.removeFromSuperview()
        addButton.snp.removeConstraints()
        addButton.removeFromSuperview()
    }

    private func setupConstraintsForPlugView() {
        view.addSubview(postButton)
        view.addSubview(plugStackView)

        plugStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.left.right.equalToSuperview().inset(20)
        }

        postButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(120)
            make.height.equalTo(70)
        }

        animationView.play()
    }

    private func getPlugStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -20

        animationView.snp.makeConstraints { $0.height.equalTo(260) }
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(noPostsLabel)

        return stackView
    }
}

// MARK: - UI + Constraints in case posts > 0
extension PublicationsViewController {
    private func configurateView() {
        view.backgroundColor = .white
        setupNavigationAppearence()
    }

    private func setupConstraints() {
        view.addSubview(welcomeLabel)
        view.addSubview(cardCollectionView)
        view.addSubview(addButton)

        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(90)
            make.left.equalToSuperview().inset(20)
        }

        cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }

        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(welcomeLabel.snp.top)
            make.right.equalToSuperview().inset(20)
        }
    }
}

// MARK:  Delegate
extension PublicationsViewController: SearchViewControllerDelegate {
    func didSelectVariant(breed: String) { }

    func didSearchButtonTapped(with searchText: String) { }

    func didPetTypeSelected(with petType: PetType) { }

    func pushToDetailVC(of publication: Publication) {
        print("Push to DetailVC")
        let detailVC = OwnDetailViewController()
        detailVC.publicationsDelegate = self
        detailVC.configure(with: publication)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func pushToParams() { }
}

// MARK: - Button logic
extension PublicationsViewController {
    @objc private func addButtonTapped(_ sender: UIButton) {
        let navigationVC = UINavigationController(rootViewController: PostViewController_1())

        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
        //navigationController?.pushViewController(PostViewController_1(), animated: true)
    }
}

// MARK: - Detail VC Delegate
extension PublicationsViewController: EditOwnPostDelegate {
    func didChangedPost(isChanged: Bool) {
        if isChanged {
            cardCollectionView.reloadData()
            print("data reloaded")
        }
    }
}
