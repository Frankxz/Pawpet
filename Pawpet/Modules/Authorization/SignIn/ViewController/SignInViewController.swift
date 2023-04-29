//
//  WelcomeViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 09.03.2023.
//

import UIKit
import SnapKit
import Firebase
import Lottie

class SignInViewController: UIViewController {

    // MARK: - Labels
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Here you'll find a pet 🐶"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .subtitleColor
        return label
    }()

    private var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have account ?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .subtitleColor
        return label
    }()

    // MARK: - Animation view
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Loading")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.2
        return view
    }()

    // MARK: - TextFields
    private var emailTextField = AuthTextField("email@mail.com")
    private var passwordTextField = AuthTextField("••••••", isSecure: true)

    // MARK: - Buttons
    private lazy var signInButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Sign in")
        return button
    }()

    private lazy var forgotButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(forgotButtonTapped(_:)), for: .touchUpInside)
        let title = NSAttributedString(
            string: "Forgot password ?",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.accentColor.withAlphaComponent(0.8)
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        let title = NSAttributedString(
            string: "Sign up now !",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.accentColor.withAlphaComponent(0.8)
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    // MARK: AlertView
    private let alertView = ErrorAlertView()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuthentication()
        configurateView()
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - UI
extension SignInViewController {
    private func configurateView() {
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        makeConstraints()
    }

    private func makeConstraints() {
        let labelStackView = getLabelStackView()
        let textFieldsStackView = getTextFieldsStackView()
        let signUpStackView = getSignUpStackView()

        view.addSubview(labelStackView)
        view.addSubview(textFieldsStackView)
        view.addSubview(signUpStackView)
        view.addSubview(forgotButton)
        view.addSubview(signInButton)
        view.addSubview(animationView)

        labelStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(200)
        }

        textFieldsStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(labelStackView.snp.bottom).offset(24)
        }

        forgotButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.top.equalTo(textFieldsStackView.snp.bottom).offset(12)
        }

        signInButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(forgotButton.snp.bottom).offset(24)
        }

        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }

        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signUpStackView.snp.bottom).offset(20)
            make.height.width.equalTo(260)
        }
    }

    private func getLabelStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        return stackView
    }

    private func getTextFieldsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)

        return stackView
    }

    private func getSignUpStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2

        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(signUpButton)

        return stackView
    }
}

// MARK: - Buttons logic
extension SignInViewController {
    @objc private func signInButtonTapped(_ sender: UIButton) {
        print("Sign in..")
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            alertView.showAlert(with: "Please fill in all fields", message: "Please enter your email and password to following fields.", on: self)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                // Обработать ошибку авторизации
                print(error.localizedDescription)
                alertView.showAlert(with: "Ooops... error!", message: "Invalid email address or password. Please try again.", on: self)
                return
            }

            // Успешная авторизация, переходим на следующий экран
            pushToMainTabBarVC()
        }
    }

    @objc private func signUpButtonTapped(_ sender: UIButton) {
        print("Sing up...")
        let navigationVC = UINavigationController(rootViewController: SignUpViewController1())
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }

    @objc private func forgotButtonTapped(_ sender: UIButton) {

    }

    @objc private func dismissAlertView() {
        alertView.dismissAlertView()
    }
    
    public func loginAfterSignUp() {
        print("loginAfterSignUp")
    }
}

// MARK: Checking auth
extension SignInViewController {
    func checkUserAuthentication() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // Пользователь авторизован, показать основной экран приложения
                print("User is signed in with ID: \(user.uid)")
                self.pushToMainTabBarVC()
            } else {
                // Пользователь не авторизован, показать экран входа
                print("User is not signed in.")

            }
        }
    }

    func pushToMainTabBarVC() {
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            let mainTabBarController = MainTabBarController()
            mainTabBarController.modalPresentationStyle = .fullScreen
            self.present(mainTabBarController, animated: true)
            self.animationView.stop()
        }
    }
}
