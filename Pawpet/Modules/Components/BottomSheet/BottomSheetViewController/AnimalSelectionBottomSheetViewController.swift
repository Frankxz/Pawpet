//
//  AnimalSelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

class AnimalSelectionBottomSheetViewController: BottomSheetViewController {

    private let animalSelectionView = AnimalSelectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

// MARK: - UI + Constraints
extension AnimalSelectionBottomSheetViewController {
    private func setupView() {
        animalSelectionView.promptView.subtitleLabel.text = "This will help you find the correct listing and also help us provide you with a list of breeds."
        animalSelectionView.nextButton.setupTitle(for: "Select")
        animalSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    private func setupConstraints() {
        containerView.addSubview(animalSelectionView)

        animalSelectionView.nextButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(430)
            make.height.equalTo(70)
        }
        animalSelectionView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Button logic
extension AnimalSelectionBottomSheetViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateDismissView()
        }
    }
}
