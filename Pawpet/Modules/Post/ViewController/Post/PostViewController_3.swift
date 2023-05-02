//
//  PostViewController_3.swift
//  Pawpet
//
//  Created by Robert Miller on 11.04.2023.
//

import UIKit
import SnapKit

class PostViewController_3: BreedSelectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        promptView.snp.remakeConstraints() { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }
    }
}

// MARK: - Button logic
extension PostViewController_3 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Eсли является помесью -> Выбрана 1-ая порода
            if self.isCrossbreed && self.isFirstBreed {
                let secondBreedVC = PostViewController_3()
                secondBreedVC.isCrossbreed = true
                secondBreedVC.isFirstBreed = false

                // TODO: FireStoreManager
                FireStoreManager.shared.currentPublication.breed = self.selectedBreed?.name ?? ""
                self.navigationController?.pushViewController(secondBreedVC, animated: true)
            } else {
                // Eсли является помесью -> Выбрана 2-ая порода
                if self.isCrossbreed  && !self.isFirstBreed{
                    // TODO: FireStoreManager
                    FireStoreManager.shared.currentPublication.secondBreed = self.selectedBreed?.name ?? ""
                }
                // Eсли не является помесью -> Выбрана порода
                if !self.isCrossbreed {
                    FireStoreManager.shared.currentPublication.breed = self.selectedBreed?.name ?? ""
                }
                self.navigationController?.pushViewController(PostViewController_4(), animated: true)
            }
        }

    }
}
