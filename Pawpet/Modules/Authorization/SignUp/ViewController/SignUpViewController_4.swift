//
//  SignUpViewController_5.swift
//  Pawpet
//
//  Created by Robert Miller on 06.04.2023.
//

import UIKit
import Lottie

class SignUpViewController_4: UIViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Enter your name",
                                        and: "This information will be visible to all users.")
    // MARK: - TextField
    private var nameTextField = AuthTextField("Name", isSecure: true)
    private var surnameTextField = AuthTextField("Surname", isSecure: true)

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK: - Lottie View
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "WatchingDog")
        view.loopMode = .loop
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        animationView.play()
    }
}

// MARK: - UI + Constraints
extension SignUpViewController_4 {
    private func configurateView() {
        view.backgroundColor = .white

        let stackView = getMainStackView()
        view.addSubview(stackView)
        view.addSubview(animationView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }

        animationView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.width.equalTo(260)
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom)
        }
    }

    private func getMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(promptView)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(surnameTextField)
        stackView.addArrangedSubview(nextButton)

        return stackView
    }
}

// MARK: - Button logic
extension SignUpViewController_4 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Full name entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(SignUpViewController_final(), animated: true)
        }
    }
}
