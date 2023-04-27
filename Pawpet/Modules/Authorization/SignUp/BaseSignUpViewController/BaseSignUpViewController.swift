//
//  SignUpViewController_1.swift
//  Pawpet
//
//  Created by Robert Miller on 14.03.2023.
//

import UIKit
import Lottie

class BaseSignUpViewController: UIViewController {

    // MARK: - PromptView
    public var promptView = PromptView(with: "", and: "")

    // MARK: - TextField
    public var textField = AuthTextField("")

    // MARK: - Button
    public lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    public var nextVC: UIViewController?

    // MARK: - Lottie View
    public var animationView: LottieAnimationView?

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        hideKeyboardWhenTappedAround()
        setupNavigationAppearence()
        configurateView()
    }
}

// MARK: - UI + Constraints
extension BaseSignUpViewController {
    private func configurateView() {
        view.addSubview(promptView)
        view.addSubview(textField)
        view.addSubview(nextButton)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }

        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
    }

    public func setupAnimationView(with animationName: String) {
        animationView = LottieAnimationView(name: animationName)
        if let animationView = animationView {
            animationView.loopMode = .loop
            animationView.layer.allowsEdgeAntialiasing = true
            animationView.contentMode = .scaleAspectFill
            animationView.play()

            view.addSubview(animationView)
            animationView.snp.makeConstraints { make in
                make.height.equalTo(140)
                make.width.equalTo(260)
                make.centerX.equalToSuperview()
                make.top.equalTo(nextButton.snp.bottom).offset(10)
            }
        }
    }

    public func removeTextField() {
        textField.removeFromSuperview()
        textField.snp.removeConstraints()

    }
}

// MARK: - Button logic
extension BaseSignUpViewController {
    @objc func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(self.nextVC!, animated: true)
        }
    }
}
