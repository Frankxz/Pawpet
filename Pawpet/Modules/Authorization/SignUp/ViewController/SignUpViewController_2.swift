//
//  SignUpViewController_2.swift
//  Pawpet
//
//  Created by Robert Miller on 20.03.2023.
//

import UIKit

class SignUpViewController_2: UIViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Enter your email",
                                        and: "This will help us in the future to send you notifications, as well as in case of account recovery.")
    // MARK: - TextField
    private var emailTextField = AuthTextField("email@mail.com")

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
extension SignUpViewController_2 {
    private func configurateView() {
        view.backgroundColor = .white

        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(nextButton)

        return stackView
    }
}

// MARK: - Button logic
extension SignUpViewController_2 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(SignUpViewController_3(), animated: true)
        }
    }
}
