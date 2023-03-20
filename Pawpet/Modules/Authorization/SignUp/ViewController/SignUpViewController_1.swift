//
//  SignUpViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 17.03.2023.
//

import UIKit
import Lottie

class SignUpViewController_1: UIViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Please,choose", and: "This is important for further registration.")

    // MARK: - Buttons
    private lazy var personalButton: OptionButton = {
        let button = OptionButton(systemImage: "person")
        button.addTarget(self, action: #selector(personalButtonTapped(_:)), for: .touchUpInside)
        button.setupSubtitle(for: "Personal use", with: 14)
        return button
    }()

    private lazy var companyButton: OptionButton = {
        let button = OptionButton(systemImage: "person.3")
        button.addTarget(self, action: #selector(companyButtonTapped(_:)), for: .touchUpInside)
        button.setupSubtitle(for: "Commercial use", with: 14)
        return button
    }()

    // MARK: - Lottie View
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "DroppedDog")
        view.loopMode = .playOnce
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
extension SignUpViewController_1 {
    private func configurateView() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        makeConstraints()
    }

    private func makeConstraints() {
        let mainStackView = getMainStackView()

        view.addSubview(mainStackView)
        view.addSubview(animationView)

        animationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(74)
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(200)
        }

        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(animationView.snp.bottom).offset(50)
        }
    }

    private func getButtonsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20

        stackView.addArrangedSubview(personalButton)
        stackView.addArrangedSubview(companyButton)

        return stackView
    }

    private func getMainStackView() -> UIStackView {
        let buttonStackView = getButtonsStackView()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(promptView)
        stackView.addArrangedSubview(buttonStackView)

        buttonStackView.snp.makeConstraints { $0.height.equalTo(200) }
        return stackView
    }
}

// MARK: - Button logic
extension SignUpViewController_1 {
    @objc private func personalButtonTapped(_ sender: UIButton) {
        print("Personal chosen")
        companyButton.layer.shadowColor = UIColor.black.cgColor
        personalButton.layer.shadowColor = UIColor.systemBlue.cgColor
        pushToNext()
        // TODO: - StorageManager

    }

    @objc private func companyButtonTapped(_ sender: UIButton) {
        print("Company chosen")
        personalButton.layer.shadowColor = UIColor.black.cgColor
        companyButton.layer.shadowColor = UIColor.systemBlue.cgColor
        pushToNext()
        // TODO: - StorageManager
    }

    private func pushToNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(SignUpViewController_2(), animated: true)
        }
    }
}
