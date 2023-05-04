//
//  BreedEditViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import UIKit

protocol BreedEditDelegate {
    func provideFirstBreed(with breed: String)
    func provideSecondBreed(with breed: String)
}

class BreedEditViewController: BreedSelectionViewController {

    public lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .accentColor
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    var editPostDelegate: BreedEditDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateConstraints()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    private func updateConstraints() {
        promptView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }
        nextButton.setupTitle(for: "Select")
        view.layoutIfNeeded()
    }
}

// MARK: - Button logic
extension BreedEditViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Eсли является помесью -> Выбрана 1-ая порода
            if self.isCrossbreed && self.isFirstBreed {
                let secondBreedVC = BreedEditViewController()
                secondBreedVC.editPostDelegate = self.editPostDelegate
                secondBreedVC.isCrossbreed = true
                secondBreedVC.isFirstBreed = false

                // TODO: FireStoreManager
                self.editPostDelegate?.provideFirstBreed(with: self.selectedBreed?.name ?? "")
                self.navigationController?.pushViewController(secondBreedVC, animated: true)
            } else {
                // Eсли является помесью -> Выбрана 2-ая порода
                if self.isCrossbreed  && !self.isFirstBreed{
                    // TODO: FireStoreManager
                    self.editPostDelegate?.provideSecondBreed(with: self.selectedBreed?.name ?? "")
                }
                // Eсли не является помесью -> Выбрана порода
                if !self.isCrossbreed {
                    self.editPostDelegate?.provideFirstBreed(with: self.selectedBreed?.name ?? "")
                }
                self.dismiss(animated: true)
            }
        }

  //  }
}

extension BreedEditViewController {
    @objc func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
