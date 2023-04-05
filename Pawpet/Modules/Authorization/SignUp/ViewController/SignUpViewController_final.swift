//
//  SignUpViewController_4.swift
//  Pawpet
//
//  Created by Robert Miller on 26.03.2023.
//

import UIKit
import Lottie

class SignUpViewController_final: UIViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Everything is ready !",
                                        and: "You are signed up and can start exploring \nthe world of Pawpet",
                                        aligment: .center)

    // MARK: - Lottie View
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "ReadyCoala")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        animationView.play()
        
    }
}

// MARK: - UI + Constraints
extension SignUpViewController_final {
    private func configurateView() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true

        let stackView = getInfoStackView()
        view.addSubview(stackView)
        view.addSubview(nextButton)

        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }

    }

    private func getInfoStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10

        animationView.snp.makeConstraints { $0.height.equalTo(200)}

        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(promptView)

        return stackView
    }
}

// MARK: - Button logic
extension SignUpViewController_final {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Registered")
        
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.present(mainTabBarController, animated: true)
        }
    }
}
