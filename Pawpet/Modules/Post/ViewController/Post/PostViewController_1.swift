//
//  PostViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 08.04.2023.
//

import UIKit

class PostViewController_1: UIViewController {

    // MARK: Animal selectionView
    private let animalSelectionView = AnimalSelectionView()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        animalSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - UI + Constraints
extension PostViewController_1 {
    private func setupConstraints() {
        view.addSubview(animalSelectionView)
        animalSelectionView.addSubview(closeButton)

        animalSelectionView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
        }
    }

    private func setupView() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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

