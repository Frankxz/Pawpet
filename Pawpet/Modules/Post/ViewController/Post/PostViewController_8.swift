//
//  PostViewController_8.swift
//  Pawpet
//
//  Created by Robert Miller on 01.05.2023.
//

import UIKit
import Lottie

class PostViewController_8: UIViewController {
    // MARK: - PromptView
    private var promptView = PromptView(with: "Enter the price",
                                        and: "If you do not want to specify anything in the description, you can skip this step.", titleSize: 32)

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK: - TextField
    private var priceTF = PriceTextField(frame: .zero)

    // MARK: - Control
    private let isFreeLabel: UILabel = {
        let label = UILabel()
        label.text = "Set no price and make free: "
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .accentColor
        return label
    }()

    private var isFreeControl = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: 120, height: 40), items: [" ", "FREE"])

    // MARK: - Animation view
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Loading")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.2
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationAppearence()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        addKeyBoardObservers()
    }
}

// MARK: - UI + Constraints
extension PostViewController_8 {
    private func setupConstraints() {
        view.addSubview(promptView)
        view.addSubview(priceTF)
        view.addSubview(isFreeControl)
        view.addSubview(isFreeLabel)
        view.addSubview(nextButton)
        view.addSubview(animationView)
        
        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }

        priceTF.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(isFreeControl.snp.bottom).offset(20)
            make.height.equalTo(70)
        }

        isFreeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }

        isFreeControl.snp.makeConstraints { make in
            make.left.equalTo(isFreeLabel.snp.right).offset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }

        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(priceTF.snp.bottom).offset(20)
            make.height.width.equalTo(260)
        }
    }
}

// MARK: - Button logic
extension PostViewController_8 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        animationView.play()

        // TODO: StorageManager
        var price = Int(priceTF.text ?? "0") ?? 0
        if isFreeControl.selectedItem == "FREE" { price = 0 }
        FireStoreManager.shared.currentPublication.price = price

        FireStoreManager.shared.savePublication { result in

            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.navigationController?.pushViewController(PostViewController_Final(), animated: true)
                    self.animationView.stop()
                }
            case .failure(let error):
                let alertView = ErrorAlertView()
                alertView.showAlert(with: "Oops! Error...", message: error.localizedDescription, on: self)
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - KeyBoard logic
extension PostViewController_8 {
    private func addKeyBoardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            nextButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(keyboardHeight + 10)
                make.height.equalTo(70)
            }

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        nextButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(70)
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
