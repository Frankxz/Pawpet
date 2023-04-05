//
//  SignUpViewController_3.swift
//  Pawpet
//
//  Created by Robert Miller on 21.03.2023.
//

import UIKit
import Lottie

class SignUpViewController_3: UIViewController {
    // MARK: - PromptView
    private var promptView = PromptView(with: "Create your password",
                                        and: "This will help you to enter the application")
    // MARK: - TextField
    private var firstTextField = AuthTextField("••••••", isSecure: true)

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
extension SignUpViewController_3 {
    private func configurateView() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let stackView = getMainStackView()
        view.addSubview(stackView)
        view.addSubview(animationView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }

        animationView.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.width.equalTo(320)
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(10)
        }
    }

    private func getMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(promptView)
        stackView.addArrangedSubview(firstTextField)
        stackView.addArrangedSubview(nextButton)

        return stackView
    }
}

// MARK: - Button logic
extension SignUpViewController_3 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Password entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(SignUpViewController_4(), animated: true)
        }
    }
}
