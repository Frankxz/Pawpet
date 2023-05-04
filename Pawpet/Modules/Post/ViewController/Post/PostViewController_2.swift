//
//  PostViewController_2.swift
//  Pawpet
//
//  Created by Robert Miller on 11.04.2023.
//

import UIKit

class PostViewController_2: UIViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Is your animal a crossbreed?",
                                        and: "If your pet is a crossbreed, you will be able to choose the breeds of the mother and father of the pet.")

    private lazy var yesButton: OptionButton = {
        let button = OptionButton(systemImage: "checkmark.circle", size: 49)
        button.addTarget(self, action: #selector(yesButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var noButton: OptionButton = {
        let button = OptionButton(systemImage: "xmark.circle", size: 49)
        button.addTarget(self, action: #selector(noButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let typeWriterLabel = LabelView(text: "", size: 18, weight: .regular, viewColor: .backgroundColor, textColor: .accentColor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationAppearence()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        typeWriterLabel.animate(newText: "A crossbreed is a pet obtained from parents of different breeds. For example, if you cross two dogs of different breeds, then their descendants will be a mixture. \n\nCrossbreeds can share the characteristics and traits of both breeds from which they are descended, and often have a unique appearance and personality.", characterDelay: 0.035)
    }
}

// MARK: - UI + Constraints
extension PostViewController_2 {
    private func setupConstraints() {
        let buttonStackView = getButtonsStackView()
        view.addSubview(promptView)
        view.addSubview(buttonStackView)
        view.addSubview(typeWriterLabel)

        typeWriterLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
        }
        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }

        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
        }
    }

    private func getButtonsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 20


        yesButton.snp.makeConstraints {$0.height.width.equalTo(160)}
        noButton.snp.makeConstraints {$0.height.width.equalTo(160)}
        stackView.addArrangedSubview(yesButton)
        stackView.addArrangedSubview(noButton)

        return stackView
    }
}

// MARK: - Button logic
extension PostViewController_2 {
    @objc private func yesButtonTapped(_ sender: UIButton) {
        print("Crossbreed chosen")
        UIView.animate(withDuration: 0.2) {
            self.noButton.imageView?.tintColor = .subtitleColor
            self.yesButton.imageView?.tintColor = .systemGreen
            self.pushToNext(isCrossBreed: true)
        }
        // TODO: - StorageManager
        PublicationManager.shared.currentPublication.petInfo.isCrossbreed = true
    }

    @objc private func  noButtonTapped(_ sender: UIButton) {
        print("No crossbreed chosen")
        UIView.animate(withDuration: 0.2) {
            self.noButton.imageView?.tintColor = .systemRed
            self.yesButton.imageView?.tintColor = .subtitleColor
            self.pushToNext(isCrossBreed: false)
        }
        // TODO: - PublicationManager
        PublicationManager.shared.currentPublication.petInfo.isCrossbreed = false
    }

    private func pushToNext(isCrossBreed: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let firstBreedVC = PostViewController_3()
            firstBreedVC.isCrossbreed = isCrossBreed
            firstBreedVC.isFirstBreed = isCrossBreed

            self.navigationController?.pushViewController(firstBreedVC, animated: true)
        }
    }
}
