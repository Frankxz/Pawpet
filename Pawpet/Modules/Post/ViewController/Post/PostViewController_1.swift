//
//  PostViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 08.04.2023.
//

import UIKit

class PostViewController_1: UIViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Select the type of pet.",
                                        and: "This will help users find your listing faster and will also help us provide you with a list of breeds.")

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK:  Buttons
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .accentColor
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - CollectionView
    private let chapterCollectionView = ChapterCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupConstraints()

    }
}

// MARK: - UI + Constraints
extension PostViewController_1 {
    private func setupConstraints() {
        view.addSubview(nextButton)
        view.addSubview(promptView)
        view.addSubview(chapterCollectionView)
        view.addSubview(closeButton)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }

        chapterCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(250)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }

        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Button logic
extension PostViewController_1 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(PostViewController_2(), animated: true)
        }
    }

    @objc private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

