//
//  PostViewController_5.swift
//  Pawpet
//
//  Created by Robert Miller on 12.04.2023.
//

import UIKit

class PostViewController_5: UIViewController {
    private let petInfoView = PetInfoSelectionView(isForPost: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        petInfoView.isForPost = true
        setupNavigationAppearence()
        petInfoView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        setupConstraints()
    }
}

// MARK: - UI + Constraints
extension PostViewController_5 {
    private func setupConstraints() {
        view.addSubview(petInfoView)
        petInfoView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(100)
        }
        petInfoView.nextButton.snp.removeConstraints()
        petInfoView.nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}


// MARK: - Button logic
extension PostViewController_5 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(PostViewController_6(), animated: true)
        }
        // TODO: - PublicationManager
        PublicationManager.shared.currentPublication.petInfo.isVaccinated = petInfoView.isVacinated
        PublicationManager.shared.currentPublication.petInfo.isCupping = petInfoView.isCupping
        PublicationManager.shared.currentPublication.petInfo.isSterilized = petInfoView.isSterilized
        PublicationManager.shared.currentPublication.petInfo.isWithDocuments = petInfoView.isWithDocuments
    }
}
