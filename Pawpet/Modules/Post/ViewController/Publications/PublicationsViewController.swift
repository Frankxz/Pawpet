//
//  PostViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit
import Lottie

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
    private let postButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Post")
        return button
    }()

    // MARK: - In case > 0 posts
    
    // MARK:  Labels
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "", boldString: "My Publications", font: .systemFont(ofSize: 32))
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    // MARK:  CollectionView
    private let cardCollectionView = CardCollectionView(isHeaderIn: false)

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
        cardCollectionView.cardsCount = 2
        cardCollectionView.searchViewControllerDelegate = self
        //setupConstraintsForPlugView()
    }
}

// MARK: - UI + Constraints in case posts = 0
extension PublicationsViewController {
    private func setupConstraintsForPlugView() {
        let stackView = getPlugStackView()

        view.addSubview(postButton)
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.left.right.equalToSuperview().inset(20)
        }

        postButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(120)
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
        cardCollectionView.cardsCount = 6
        view.backgroundColor = .white
        setupNavigationAppearence()
        setupConstraints()
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
    func pushToParams() { }

    func pushToDetailVC() {
        print("Push to DetailVC")
        navigationController?.pushViewController(OwnDetailViewController(), animated: true)
    }
}

// MARK: - Button logic
extension PublicationsViewController {
    @objc private func addButtonTapped(_ sender: UIButton) {
        let navigationVC = UINavigationController(rootViewController: PostViewController_1())
        navigationVC.modalPresentationStyle = .pageSheet
        present(navigationVC, animated: true)
       // navigationController?.pushViewController(PostViewController_1(), animated: true)
    }
}
