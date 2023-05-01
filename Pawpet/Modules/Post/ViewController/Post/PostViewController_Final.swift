//
//  PostViewController_8.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit
import Lottie

class PostViewController_Final: UIViewController {
    // MARK: Lottie View
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Success")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - PromptView
    private var promptView = PromptView(with: "Your ad has been published!",
                                        and: "It remains only to wait until someone notices your ad and is interested in it.", titleSize: 36, aligment: .center)

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Close")
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UI + Constraints
extension PostViewController_Final {
    private func setupConstraints() {
        let stackView = getCenterStackView()

        view.addSubview(nextButton)
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.right.equalToSuperview().inset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }

        animationView.play()
    }

    private func getCenterStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -100

        animationView.snp.makeConstraints { $0.height.equalTo(360) }
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(promptView)

        return stackView
    }
}

// MARK: - Button logic
extension PostViewController_Final {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true) {
                // TODO: -
            }
        }
    }
}
