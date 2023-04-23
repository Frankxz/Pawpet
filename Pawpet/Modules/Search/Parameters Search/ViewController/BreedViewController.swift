//
//  BreedViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

class BreedViewController: BreedSelectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        updateConstraints()
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    private func updateConstraints() {
        promptView.snp.updateConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }
        view.layoutIfNeeded()
    }
}

// MARK: - Button logic
extension BreedViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.isCrossbreed && self.isFirstBreed {
                let secondBreedVC = BreedViewController()
                secondBreedVC.isCrossbreed = true
                secondBreedVC.isFirstBreed = false

                self.navigationController?.pushViewController(secondBreedVC, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
