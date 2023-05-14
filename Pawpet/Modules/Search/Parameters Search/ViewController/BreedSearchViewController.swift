//
//  BreedViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

protocol BreedSearchDelegate {
    func didSelectBreed(firstBreed: String)
    func didSelectBreed(secondBreed: String?)
}

class BreedSearchViewController: BreedSelectionViewController {
    // MARK: Button
    private lazy var cancelButton: UIBarButtonItem = {
        let customAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.accentColor]
        let saveButtonTitle = NSAttributedString(string: "Cancel".localize(), attributes: customAttributes)
        let saveButton = UIButton(type: .system)
        saveButton.setAttributedTitle(saveButtonTitle, for: .normal)
        saveButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        return saveBarButton
    }()
    
    var paramsDelegate: BreedSearchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateConstraints()
        
        if !isCrossbreed || (isCrossbreed && isFirstBreed) {
            navigationItem.rightBarButtonItem = cancelButton
        }

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
extension BreedSearchViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Eсли является помесью -> Выбрана 1-ая порода
            if self.isCrossbreed && self.isFirstBreed {
                let secondBreedVC = BreedSearchViewController()
                secondBreedVC.setupBreeds(breeds: self.breeds)
                secondBreedVC.isCrossbreed = true
                secondBreedVC.isFirstBreed = false

                // TODO: PublicationManager
                self.paramsDelegate?.didSelectBreed(firstBreed: self.selectedBreed?.name ?? "")
                self.navigationController?.pushViewController(secondBreedVC, animated: true)
            } else {
                // Eсли является помесью -> Выбрана 2-ая порода
                if self.isCrossbreed  && !self.isFirstBreed{
                    // TODO: FireStoreManager
                    self.paramsDelegate?.didSelectBreed(secondBreed: self.selectedBreed?.name)
                }
                // Eсли не является помесью -> Выбрана порода
                if !self.isCrossbreed {
                    self.paramsDelegate?.didSelectBreed(firstBreed: self.selectedBreed?.name ?? "")
                }
                self.dismiss(animated: true)
            }
        }
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
