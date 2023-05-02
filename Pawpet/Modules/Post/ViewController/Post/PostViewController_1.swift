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

    var publication = Publication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        animalSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
}

// MARK: - UI + Constraints
extension PostViewController_1 {
    private func setupConstraints() {
        view.addSubview(animalSelectionView)
        animalSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.left.right.bottom.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
    }

    private func setupView() {
        view.backgroundColor = .white
        setupNavigationAppearence()
    }
}

// MARK: - Button logic
extension PostViewController_1 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let type = self.animalSelectionView.chapterCollectionView.selectedType
            FireStoreManager.shared.currentPublication.petType = type
            self.navigationController?.pushViewController(PostViewController_2(), animated: true)
        }
    }

    @objc private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

