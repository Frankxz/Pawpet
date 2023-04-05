//
//  PostViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit
import Lottie

class PostViewController: UIViewController {

    // MARK: - Lottie View
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "SadDog")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - Labels
    private let noPostsLabel = PromptView(with: "Oops, here is no posts yet... ", and: "It's time to add, try it, it's very easy!", aligment: .center)

    // MARK: - Buttons
    private let postButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Post")
        return button
    }()


    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.play()
        setupConstraints()
    }
}

// MARK: - UI + Constraints
extension PostViewController {
    private func setupConstraints() {
        let stackView = getMainStackView()

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
    }

    private func getMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -20

        animationView.snp.makeConstraints { $0.height.equalTo(260) }
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(noPostsLabel)

        return stackView
    }
}
