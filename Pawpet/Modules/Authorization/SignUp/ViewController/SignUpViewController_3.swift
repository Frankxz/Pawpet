//
//  SignUpViewController_3.swift
//  Pawpet
//
//  Created by Robert Miller on 21.03.2023.
//

import UIKit

class SignUpViewController_3: UIViewController {
    // MARK: - PromptView
    private var promptView = PromptView(with: "Create your password",
                                        and: "This will help you to enter the application")
    // MARK: - TextField
    private var firstTextField = AuthTextField("••••••", isSecure: true)
    private var secondTextField = AuthTextField("••••••", isSecure: true)

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
    }
}

// MARK: - UI + Constraints
extension SignUpViewController_3 {
    private func configurateView() {
        view.backgroundColor = .white
        
        let stackView = getMainStackView()
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }
    }

    private func getMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(promptView)
        stackView.addArrangedSubview(firstTextField)
        stackView.addArrangedSubview(secondTextField)
        stackView.addArrangedSubview(nextButton)

        return stackView
    }
}

// MARK: - Button logic
extension SignUpViewController_3 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Password entered")

    }
}
