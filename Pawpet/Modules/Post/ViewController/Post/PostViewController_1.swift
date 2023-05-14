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
        animalSelectionView.chapterCollectionView.petTypes = PetType.allCases.filter { $0 != .all }
        animalSelectionView.chapterCollectionView.reloadData()
        animalSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
}

// MARK: - UI + Constraints
extension PostViewController_1 {
    private func setupConstraints() {
        view.addSubview(animalSelectionView)
        animalSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
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
            PublicationManager.shared.currentPublication.petInfo.petType = type
            
            if type == .cat || type == .dog {
                self.navigationController?.pushViewController(PostViewController_2(), animated: true)
            } else {
                let breedVC = PostViewController_3()
                breedVC.promptView.titleLabel.text = "Выберите вид питомца"
                breedVC.isCrossbreed = false
                breedVC.isFirstBreed = false

                BreedManager.shared.loadData(for: type) { fetchedBreeds in
                    breedVC.setupBreeds(stringBreeds: fetchedBreeds)
                    self.navigationController?.pushViewController(breedVC, animated: true)
                }
            }
        }
    }

    @objc private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

